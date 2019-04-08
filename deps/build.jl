# download spec schema, javascript files, and installs nodes js packages

using BinDeps
@BinDeps.setup

uschema   = "https://vega.github.io/schema/vega-lite/v3.0.0.json"
uvega     = "https://cdnjs.cloudflare.com/ajax/libs/vega/5.3.2/vega.min.js"
uvegalite = "https://cdnjs.cloudflare.com/ajax/libs/vega-lite/3.0.0/vega-lite.min.js"
uembed    = "https://cdnjs.cloudflare.com/ajax/libs/vega-embed/4.0.0/vega-embed.min.js"

destdir      = joinpath(@__DIR__, "lib")

run(@build_steps begin
  CreateDirectory(destdir, true)
  FileDownloader(uschema,   joinpath(destdir, "vega-lite-schema.json"))
  FileDownloader(uvega,     joinpath(destdir, basename(uvega)))
  FileDownloader(uvegalite, joinpath(destdir, basename(uvegalite)))
  FileDownloader(uembed,    joinpath(destdir, basename(uembed)))
end)

# install NodeJS modules
using NodeJS

run(Cmd(`$(npm_cmd()) install --production --no-bin-links --no-package-lock --no-optional`, dir=@__DIR__))
 
