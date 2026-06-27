# KidsMode for Alfred (学习模式)

一个基于 Alfred Workflow 和 macOS 系统底层权限的防沉迷工具。通过一键切换，可以将电脑在“学习模式”和“娱乐模式”之间无缝切换。

## 🌟 功能特色

- **一键切换**：只需在 Alfred 输入特定关键词，即可快速开启或关闭屏蔽。
- **系统级屏蔽**：底层直接修改 `/etc/hosts` 文件，无论是 Safari、Chrome 还是其他应用，全部生效。
- **家长专有权限**：利用 macOS 的提权机制（`osascript with administrator privileges`），每次切换都需要验证**管理员密码或触控 ID**。小孩如果不知道密码，即使知道关键词也无法绕过限制。
- **内置屏蔽列表**：目前默认屏蔽了常见的视频娱乐网站，包括：
  - B站 (bilibili.com)
  - 油管 (youtube.com)
  - 抖音 (douyin.com)
  - 腾讯视频 (v.qq.com)
  - 爱奇艺 (iqiyi.com)
  - 优酷 (youku.com)

## 📥 安装指南

1. 下载项目中的 [KidsMode.alfredworkflow](KidsMode.alfredworkflow) 文件。
2. 双击该文件，Alfred 会自动打开导入界面，点击 **Import** 即可安装。

## 🚀 使用方法

1. 呼出 Alfred（通常是 `Option + Space` 或 `Cmd + Space`）。
2. 输入关键词 `kids`，然后回车。
3. 此时系统会弹窗提示“osascript 需要修改你的电脑”：
   - 如果你是家长：输入密码或验证触控 ID 即可完成切换。
   - 如果是小孩：因为没有权限，点击取消即可，网站依旧会被屏蔽。
4. 切换成功后，系统右上角会弹出消息通知：
   - **屏蔽成功**：`🚫 学习模式已开启，视频网站已被屏蔽。`
   - **解封成功**：`✅ 娱乐网站已解封，可以放松一下了。`

## 🛠 自定义要屏蔽的网站

如果你需要添加或移除要屏蔽的网站，可以直接修改 Workflow 内的脚本：
1. 打开 Alfred 的 Workflows 面板。
2. 找到 **Kids Mode 学习模式**。
3. 双击 `Run Script` 节点，修改里面的 bash 脚本代码：
   ```bash
   # 在此处按格式添加或删除需要屏蔽的域名
   echo '127.0.0.1 www.example.com' >> /etc/hosts
   ```
4. 保存即可生效。

## ⚠️ 注意事项

- 本 Workflow 会直接修改你系统中的 `/etc/hosts` 文件，并在文件内加入 `# KIDS_MODE_START` 和 `# KIDS_MODE_END` 作为标记。请勿手动破坏这两个标记，否则可能导致无法正常解封。
- 该工具依赖 macOS 系统的 `dscacheutil -flushcache` 与 `killall -HUP mDNSResponder` 进行 DNS 缓存刷新以达到立即生效的目的。
