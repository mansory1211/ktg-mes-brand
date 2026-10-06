#!/bin/bash
#====================================================================================
#  KTG-MES 品牌资源应用脚本 v1.0
#  功能：将定制品牌资源应用到 KTG-MES 前端项目
#  用法：sudo bash apply-brand.sh <前端项目目录>
#  示例：sudo bash apply-brand.sh /root/ktg-mes-deploy/ktg-mes-ui
#====================================================================================
set -Eeuo pipefail

# 颜色输出
_info()  { printf '\033[32m[INFO]  %s\033[0m\n' "$*"; }
_warn()  { printf '\033[33m[WARN]  %s\033[0m\n' "$*"; }
_error() { printf '\033[31m[ERROR] %s\033[0m\n' "$*" >&2; }
_ok()    { printf '\033[32m✔  %s\033[0m\n' "$*"; }
_step()  { printf '\n\033[36m===== %s =====\033[0m\n' "$*"; }

# ======================= 配置 =======================
BRAND_DIR="$(cd "$(dirname "$0")/.." && pwd)"
UI_DIR="${1:-}"
BACKUP_DIR="$BRAND_DIR/backup"

# 主色配置
PRIMARY_COLOR="#0F3460"
SUCCESS_COLOR="#10b981"
WARNING_COLOR="#f59e0b"
DANGER_COLOR="#ef4444"

# 菜单配色
MENU_BACKGROUND="#1a2a3a"
SUB_MENU_BACKGROUND="#0f1e2e"
SUB_MENU_HOVER="#0F3460"

# 系统名称
SYSTEM_NAME="KTG-MES"
SYSTEM_TITLE="KTG-MES 生产执行系统"
COMPANY_NAME="骏通齿轮加工有限公司"

# ======================= 前置检查 =======================
if [ -z "$UI_DIR" ]; then
    _error "请指定前端项目目录：bash $0 <前端项目路径>"
    _error "示例：bash $0 /root/ktg-mes-deploy/ktg-mes-ui"
    exit 1
fi

if [ ! -d "$UI_DIR" ]; then
    _error "前端目录不存在：$UI_DIR"
    exit 1
fi

if [ ! -f "$UI_DIR/package.json" ]; then
    _error "目录不是前端项目（未找到 package.json）：$UI_DIR"
    exit 1
fi

_info "前端项目目录：$UI_DIR"
_info "品牌资源目录：$BRAND_DIR"

# ======================= 备份 =======================
_step "备份原文件"

mkdir -p "$BACKUP_DIR"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_SUBDIR="$BACKUP_DIR/$TIMESTAMP"
mkdir -p "$BACKUP_SUBDIR"

# 备份关键文件
BACKUP_FILES=(
    "src/assets/logo/logo.png"
    "src/assets/styles/element-variables.scss"
    "src/assets/styles/variables.scss"
    "src/layout/components/Sidebar/Logo.vue"
    "src/views/login.vue"
    "public/index.html"
    ".env.development"
    ".env.production"
    "package.json"
)

for f in "${BACKUP_FILES[@]}"; do
    if [ -f "$UI_DIR/$f" ]; then
        mkdir -p "$BACKUP_SUBDIR/$(dirname "$f")"
        cp "$UI_DIR/$f" "$BACKUP_SUBDIR/$f"
        _info "备份：$f"
    fi
done

_ok "备份完成，备份目录：$BACKUP_SUBDIR"

# ======================= 1. 替换 Logo =======================
_step "替换 Logo 资源"

# 侧边栏 Logo
if [ -f "$BRAND_DIR/logo/logo-primary.png" ]; then
    mkdir -p "$UI_DIR/src/assets/logo"
    cp "$BRAND_DIR/logo/logo-primary.png" "$UI_DIR/src/assets/logo/logo.png"
    _ok "侧边栏 Logo 已替换"
fi

# Favicon
if [ -f "$BRAND_DIR/logo/favicon.png" ]; then
    cp "$BRAND_DIR/logo/favicon.png" "$UI_DIR/public/favicon.png"
    _info "Favicon 已替换"
fi

# ======================= 2. 替换主题色变量 =======================
_step "应用主题色定制"

# element-variables.scss
ELEMENT_VARS="$UI_DIR/src/assets/styles/element-variables.scss"
if [ -f "$ELEMENT_VARS" ]; then
    # 替换主色
    sed -i "s/\\\$--color-primary: .*/\\\$--color-primary: $PRIMARY_COLOR;/" "$ELEMENT_VARS"
    sed -i "s/\\\$--color-success: .*/\\\$--color-success: $SUCCESS_COLOR;/" "$ELEMENT_VARS"
    sed -i "s/\\\$--color-warning: .*/\\\$--color-warning: $WARNING_COLOR;/" "$ELEMENT_VARS"
    sed -i "s/\\\$--color-danger: .*/\\\$--color-danger: $DANGER_COLOR;/" "$ELEMENT_VARS"
    _ok "Element UI 主题色已更新"
fi

# variables.scss (菜单配色)
VARS_FILE="$UI_DIR/src/assets/styles/variables.scss"
if [ -f "$VARS_FILE" ]; then
    sed -i "s/\\\$base-menu-background:.*/\\\$base-menu-background:$MENU_BACKGROUND;/" "$VARS_FILE"
    sed -i "s/\\\$base-sub-menu-background:.*/\\\$base-sub-menu-background:$SUB_MENU_BACKGROUND;/" "$VARS_FILE"
    sed -i "s/\\\$base-sub-menu-hover:.*/\\\$base-sub-menu-hover:$SUB_MENU_HOVER;/" "$VARS_FILE"
    sed -i "s/\\\$base-menu-color-active:.*/\\\$base-menu-color-active:#ffffff;/" "$VARS_FILE"
    _ok "侧边栏菜单配色已更新"
fi

# ======================= 3. 修改系统名称 =======================
_step "修改系统名称"

# 侧边栏标题
LOGO_VUE="$UI_DIR/src/layout/components/Sidebar/Logo.vue"
if [ -f "$LOGO_VUE" ]; then
    sed -i "s/title: '.*'/title: '$SYSTEM_NAME'/" "$LOGO_VUE"
    _ok "侧边栏系统名称已更新为 $SYSTEM_NAME"
fi

# 环境变量标题
ENV_DEV="$UI_DIR/.env.development"
ENV_PROD="$UI_DIR/.env.production"
if [ -f "$ENV_DEV" ]; then
    sed -i "s/VUE_APP_TITLE = .*/VUE_APP_TITLE = $SYSTEM_TITLE/" "$ENV_DEV"
    _ok "开发环境标题已更新"
fi
if [ -f "$ENV_PROD" ]; then
    sed -i "s/VUE_APP_TITLE = .*/VUE_APP_TITLE = $SYSTEM_TITLE/" "$ENV_PROD"
    _ok "生产环境标题已更新"
fi

# package.json 描述
PKG_JSON="$UI_DIR/package.json"
if [ -f "$PKG_JSON" ]; then
    sed -i "s/\"description\": \".*\"/\"description\": \"$SYSTEM_TITLE（$COMPANY_NAME 定制版）\"/" "$PKG_JSON"
    _ok "package.json 描述已更新"
fi

# ======================= 4. 定制登录页 =======================
_step "定制登录页"

LOGIN_VUE="$UI_DIR/src/views/login.vue"
if [ -f "$LOGIN_VUE" ]; then
    # 替换标题
    sed -i "s|<h3 class=\"title\">.*</h3>|<h3 class=\"title\">$SYSTEM_TITLE</h3>|" "$LOGIN_VUE"

    # 替换背景为深蓝渐变
    sed -i "s|background-image: url.*|background: linear-gradient(135deg, $PRIMARY_COLOR 0%, #16467A 100%);|" "$LOGIN_VUE"
    sed -i "s|background-size: cover;||" "$LOGIN_VUE"

    # 替换标题颜色
    sed -i "s|color: #707070;|color: $PRIMARY_COLOR;|" "$LOGIN_VUE"

    _ok "登录页样式已定制"
fi

# ======================= 5. 定制加载页背景 =======================
_step "定制加载页背景"

INDEX_HTML="$UI_DIR/public/index.html"
if [ -f "$INDEX_HTML" ]; then
    # 替换加载背景色
    sed -i "s|background: #.*;|background: $PRIMARY_COLOR;|" "$INDEX_HTML"
    _ok "加载页背景色已更新"
fi

# ======================= 完成 =======================
_step "品牌应用完成"

cat << EOF

✅ KTG-MES 品牌资源已成功应用！

📁 前端目录：$UI_DIR
💾 备份目录：$BACKUP_SUBDIR

🔧 接下来请执行：
   cd $UI_DIR
   npm install
   npm run build:prod

📝 已修改内容：
   - Logo：JT 环形传动标
   - 主色：$PRIMARY_COLOR（工业深蓝）
   - 系统名：$SYSTEM_NAME
   - 登录页：深蓝渐变背景
   - 侧边栏：深色工业蓝菜单
   - 加载页：深蓝背景

EOF
