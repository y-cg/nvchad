## Existing Issues

Inlay hints out of date:

Some lsps may have a extremely long starting time, e.g. Rust. So neovim may unintentionally use the invalid inlayhints information beacause the inlayhints are drawn in the `on_attach` stage. This can be fixed manually by inserting some random text to re-trigger the computation of inlayhints. See [this issue](https://github.com/neovim/neovim/issues/26511) for more info.
