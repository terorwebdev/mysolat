defmodule Mysolat.Mysolat_app do
    import SweetXml

    @base_url "https://www.e-solat.gov.my/index.php?r=esolatApi/xmlfeed&zon="

    def get_data(zone) do
        case req_url(zone) do
            {:ok, {_http, _header, body}} ->
                case body do
                    [] ->
                        {:error, []}
                    data ->
                        {:ok, clean_data(to_string(body))}
                end
            {:error, _repsonse} ->
                {:error, "error request url"}
        end
    end

    def clean_data(data) do
        title = parse_data(data)
        solat_list = parse_solat_time(data)
        %{
            "title" => to_string(title.title),
            "zone" => String.split(to_string(title.zone), ","),
            "source" => to_string(title.source),
            "right" => to_string(title.right),
            "date" => to_string(title.date),
            "times" => make_solat_list(solat_list)
        }
    end

    def make_solat_list(data) do
        Enum.map(data, fn item -> 
            %{
                "title" => to_string(item.title),
                "time" => to_string(item.time)
            }
        end)
    end

    def parse_data(data) do
        data 
        |> xpath(~x"/rss/channel", 
            title: ~x"./title/text()",
            zone: ~x"./description/text()",
            source: ~x"./dc:creator/text()",
            right: ~x"./dc:rights/text()",
            date: ~x"./dc:date/text()")
    end

    def parse_solat_time(data) do
        data 
        |> xpath(~x"/rss/channel/item"l, 
            title: ~x"./title/text()",
            time: ~x"./description/text()")
    end

    def req_url(zone) do
        req_url = Enum.join([@base_url,  zone], "")
            |> String.to_charlist
            |> :httpc.request
    end

end