defmodule App.Search do
  @moduledoc """
    Functions for searching through resources with a query and checking if query
    terms are in resource anywhere. Excludes stop words ('a', 'and', 'the' etc.)
    and takes typos into account.
  """
  @stop_words "stop_words.txt" |> File.read! |> String.split(",")

  def find_matches(%{tags: tags, body: body, heading: heading} = params, query) do
    split_tags = Enum.reduce(tags, [], fn {_type, tags}, acc -> acc ++ tags end)

    fields = [split_tags, split_text(body), split_text(heading)]

    if is_list query do
      filtered_query = Enum.filter(query, fn q -> !(q in @stop_words) end)

      case length filtered_query do
        1 -> Enum.any?(fields, &(find_matches &1, List.first filtered_query))
        _ -> Enum.all?(filtered_query, &(find_matches params, &1))
      end
    else
      Enum.any?(fields, &(find_matches &1, query))
    end
  end

  def find_matches(list, string) when is_binary(string) and is_list(list) do
    Enum.any?(list, &(find_matches &1, string))
  end

  def find_matches(string1, string2)
  when is_binary string1 and is_binary string2 do
    string1
    |> String.downcase
    |> String.split(~r/[\-\s]/)
    |> Enum.any?(&(String.jaro_distance(&1, String.downcase(string2)) > 0.88))
  end

  def split_text(text) do
    ~r/\w[a-zA-Z]+\w/
    |> Regex.scan(text)
    |> Enum.map(fn [regex] -> regex end)
  end
end
