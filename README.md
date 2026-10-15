# 配件管理端系分图稿

本仓库保存《配件管理端系分》的交互截图和 Archify 图稿。

在线预览：<https://hanserwei.github.io/accessory-management-design-assets/>

当前版本：v0.6（2026-10-15）。[阅读系分文档](系分-配件管理端.md)。已确认validity_status独立列及ext_info失效原因JSON；3.6.3附按日常库规范编写的三表建表SQL，供审核，未执行。[下载SQL](docs/sql/packing-rule-schema.sql)。现有Archify图稿保留v0.5模型结构，字段方案以v0.6系分和SQL为准。

内容包括：

- `docs/assets/images/`：交互截图、模型图、时序图 PNG。
- `docs/archify/*.html`：可交互的 Archify 图稿。
- `docs/archify/*.svg`：静态 SVG 图稿。
- `docs/archify/*-candidate.json`：Archify 可编辑源文件。
- `docs/sql/packing-rule-schema.sql`：规则三表建表SQL审核稿。

GitHub Pages 使用 `docs/` 目录发布。Markdown 文档可直接引用 `https://hanserwei.github.io/accessory-management-design-assets/` 下的图片和图稿链接。
