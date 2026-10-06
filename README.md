# KTG-MES 品牌定制资源库

> 基于 KTG-MES 开源 MES 框架的品牌定制资源
> 定制方：骏通齿轮加工有限公司
> 主色：工业深蓝 `#0F3460`

---

## 仓库说明

本仓库存放 KTG-MES 的品牌定制资源，与原版 KTG-MES 源码**完全分离**。

使用方式：一键部署脚本先 clone 原版 KTG-MES 源码，再 clone 本仓库，执行 `apply-brand.sh` 应用定制。

---

## 目录结构

```text
ktg-mes-brand/
├── logo/                    # Logo 资源
│   ├── logo-primary.png     # 主 Logo（侧边栏用）
│   ├── logo-inverse.png     # 反白 Logo（深色背景用）
│   └── favicon.png          # 浏览器标签小图标
├── theme/                   # 主题色配置参考
│   ├── element-variables.scss  # Element UI 主题色模板
│   └── variables.scss           # 侧边栏配色模板
├── login/                   # 登录页定制资源（预留）
├── scripts/
│   └── apply-brand.sh       # 品牌应用脚本（核心）
├── backup/                  # 备份目录（自动生成）
└── README.md                # 本文件
```

---

## 快速使用

### 方式1：一键脚本自动应用（推荐）

在一键部署脚本中加入以下步骤：

```bash
# 1. Clone 原版 KTG-MES 源码
git clone https://gitee.com/kutangguo/ktg-mes.git
git clone https://gitee.com/kutangguo/ktg-mes-ui.git

# 2. Clone 品牌资源仓库
git clone https://github.com/你的账号/ktg-mes-brand.git

# 3. 应用品牌定制
sudo bash ktg-mes-brand/scripts/apply-brand.sh ./ktg-mes-ui

# 4. 构建前端
cd ktg-mes-ui && npm install && npm run build:prod
```

### 方式2：手动应用

```bash
# 克隆品牌仓库
git clone https://github.com/你的账号/ktg-mes-brand.git

# 应用到前端项目
cd ktg-mes-brand
bash scripts/apply-brand.sh /path/to/ktg-mes-ui

# 重新构建
cd /path/to/ktg-mes-ui
npm run build:prod
```

---

## 定制内容清单

| 项目 | 原值 | 定制后 |
|---|---|---|
| 系统名称 | 苦糖果MES | KTG-MES |
| 页面标题 | 苦糖果MES-软件开发记录 | KTG-MES 生产执行系统 |
| 主色 | `#1890ff` | `#0F3460`（工业深蓝） |
| 成功色 | `#13ce66` | `#10b981` |
| 警告色 | `#ffba00` | `#f59e0b` |
| 危险色 | `#ff4949` | `#ef4444` |
| 侧边栏背景 | `#304156` | `#1a2a3a` |
| 子菜单背景 | `#1f2d3d` | `#0f1e2e` |
| 子菜单 hover | `#001528` | `#0F3460` |
| Logo | 若依默认 | JT 环形传动标 |
| 登录页背景 | 图片 | 深蓝渐变 |
| 加载页背景 | 紫色 `#7171C6` | 深蓝 `#0F3460` |

---

## 备份与回滚

apply-brand.sh 会自动备份原文件到 `backup/` 目录，格式：

```text
backup/
└── 20260101_120000/
    ├── src/assets/logo/logo.png
    ├── src/assets/styles/element-variables.scss
    ├── src/layout/components/Sidebar/Logo.vue
    └── ...
```

回滚方法：

```bash
# 恢复备份
cp -r backup/20260101_120000/* /path/to/ktg-mes-ui/
```

---

## 自定义修改

如需修改品牌色或系统名，编辑 `scripts/apply-brand.sh` 顶部配置：

```bash
PRIMARY_COLOR="#0F3460"      # 主色
SUCCESS_COLOR="#10b981"      # 成功色
WARNING_COLOR="#f59e0b"      # 警告色
DANGER_COLOR="#ef4444"       # 危险色
SYSTEM_NAME="KTG-MES"        # 系统简称
SYSTEM_TITLE="KTG-MES 生产执行系统"  # 完整标题
COMPANY_NAME="骏通齿轮加工有限公司"   # 公司名
```

---

## 注意事项

1. **仓库必须公开**：一键脚本需要 clone，私有仓库无法直接拉取
2. **不要提交构建产物**：`node_modules/`、`dist/` 加入 `.gitignore`
3. **重复执行安全**：apply-brand.sh 支持重复执行，每次都会自动备份
4. **升级原版后重新应用**：如果 KTG-MES 原版代码更新，重新 clone 后再跑一次 apply-brand.sh 即可

---

## 许可证

MIT License
