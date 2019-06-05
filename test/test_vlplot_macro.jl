using VegaLite
using FilePaths
using URIParser
using DataFrames
using Test

@testset "@vlplot macro" begin

@test @vlplot(mark={"point"}) == (vl"""
    {"mark": {"type": "point"}}
    """)

@test @vlplot("point", data={values=[{a=1}]}) == (vl"""
    {"mark": "point", "data": {"values":[{"a": 1}]}}
""")

@test @vlplot(:point, x=:foo) == @vlplot(:point, enc={x=:foo})

@test @vlplot(mark={typ=:point}) == @vlplot(mark={:point})

@test (p"/foo/bar" |> @vlplot(:point)) == @vlplot(:point, data=p"/foo/bar")

@test (p"/foo/bar" |> @vlplot(:point)) == @vlplot(:point, data={url=p"/foo/bar"})

@test (URI("http://foo.com/bar.json") |> @vlplot(:point)) == @vlplot(:point, data=URI("http://foo.com/bar.json"))

@test (URI("http://foo.com/bar.json") |> @vlplot(:point)) == @vlplot(:point, data={url=URI("http://foo.com/bar.json")})

@test (DataFrame(a=[1]) |> @vlplot(:point)) == @vlplot(:point, data=DataFrame(a=[1]))

@test @vlplot("point", transform=[{lookup="foo", from={data=p"/foo/bar", key="bar"}}]).params["transform"][1]["from"]["data"]["url"] == (Sys.iswindows() ? "file://foo/bar" : "file:///foo/bar")
@test @vlplot("point", transform=[{lookup="foo", from={data={url=p"/foo/bar"}, key="bar"}}]).params["transform"][1]["from"]["data"]["url"] == (Sys.iswindows() ? "file://foo/bar" : "file:///foo/bar")
@test @vlplot("point", transform=[{lookup="foo", from={data=URI("http://foo.com/bar.json"), key="bar"}}]).params["transform"][1]["from"]["data"]["url"] == "http://foo.com/bar.json"
@test @vlplot("point", transform=[{lookup="foo", from={data={url=URI("http://foo.com/bar.json")}, key="bar"}}]).params["transform"][1]["from"]["data"]["url"] == "http://foo.com/bar.json"

@test @vlplot("point", transform=[{lookup="foo", from={data=DataFrame(a=[1]), key="bar"}}]).params["transform"][1]["from"]["data"]["values"][1]["a"] == 1

@test [@vlplot("point") @vlplot("circle")] == (vl"""
{
    "hconcat": [
        {
            "mark": "point"
        },
        {
            "mark": "circle"
        }
    ]
}
""")

@test [@vlplot("point"); @vlplot("circle")] == (vl"""
{
    "vconcat": [
        {
            "mark": "point"
        },
        {
            "mark": "circle"
        }
    ]
}
""")

@test @vlplot("point", x={"foo:q"}) == (vl"""
{
    "mark": "point",
    "encoding": {
        "x": {
            "field": "foo",
            "type": "quantitative"
        }
    }
}
""")

@test (@vlplot(description="foo") + @vlplot(:point) + @vlplot(:circle)) == @vlplot(description="foo", layer=[{mark=:point},{mark=:circle}])

@test (@vlplot(facet={row={field=:foo, typ=:bar}}) + @vlplot(:point)) == @vlplot(facet={row={field=:foo, typ=:bar}}, spec={mark=:point})

@test (@vlplot(repeat={column=[:foo, :bar]}) + @vlplot(:point)) == @vlplot(repeat={column=[:foo, :bar]}, spec={mark=:point})

@test (@vlplot(description="foo") + [@vlplot(:point) @vlplot(:circle)]) == @vlplot(description="foo", hconcat=[{mark=:point},{mark=:circle}])

@test (@vlplot(description="foo") + [@vlplot(:point); @vlplot(:circle)]) == @vlplot(description="foo", vconcat=[{mark=:point},{mark=:circle}])

@test (@vlplot(:point, x=:a)(DataFrame(a=[1])) == @vlplot(:point, data=DataFrame(a=[1]), x=:a))

end
