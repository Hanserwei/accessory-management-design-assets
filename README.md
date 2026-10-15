# 配件管理端系分图稿

本仓库保存《配件管理端系分》的交互截图和 Archify 图稿。

在线预览：<https://hanserwei.github.io/accessory-management-design-assets/>

当前版本：v0.5（2026-10-15）。[阅读系分文档](系分-配件管理端.md)。规则仅总部唯一一套、无门店副本；门店删除SKU/加料/做法不修改规则；SKU逐个选择。总部删除后原AND维度删空标为“已失效”，推荐独立validityStatus=VALID/EXPIRED以保留商户启停意图。Q3/Q4已明确，addOnsType默认值及失效恢复交互仍待评审。

内容包括：

- `docs/assets/images/`：交互截图、模型图、时序图 PNG。
- `docs/archify/*.html`：可交互的 Archify 图稿。
- `docs/archify/*.svg`：静态 SVG 图稿。
- `docs/archify/*-candidate.json`：Archify 可编辑源文件。

GitHub Pages 使用 `docs/` 目录发布。Markdown 文档可直接引用 `https://hanserwei.github.io/accessory-management-design-assets/` 下的图片和图稿链接。
