using Test
using VegaLite

@testset "show" begin

vl = @vlplot(:point)
vg = VegaLite.VGSpec(Dict{String,Any}())

@test sprint(show, "text/plain", vl) == "VegaLite.VLSpec{:plot}"

@test sprint(show, "text/plain", vg) == "VegaLite.VGSpec"

@test_throws ArgumentError sprint(show, "image/svg+xml", @vlplot())

@test istextmime("application/vnd.vegalite.v2+json")

@test istextmime("application/vnd.vega.v4+json")

@test sprint(show, "application/vnd.vegalite.v2+json", @vlplot(:point)) == "{\"mark\":\"point\"}"

@test sprint(show, "application/vnd.vega.v4+json", vg"{}") == "{}"

end
