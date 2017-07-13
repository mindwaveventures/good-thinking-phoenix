defmodule App.SearchTest do
  use App.ConnCase, async: false
  import App.SearchFixtures, only: [resources: 0]
  alias App.Search

  test "Search" do
    assert resources()
    |> Enum.filter(&(Search.find_matches &1, Search.split_text "NHS"))
    |> length == 1
  end

  test "Search - case insensitive" do
    assert resources()
    |> Enum.filter(&(Search.find_matches &1, Search.split_text "SLEep tEsT"))
    |> length == 1
  end

  test "Search - long string" do
    assert resources()
    |> Enum.filter(&(Search.find_matches &1, Search.split_text "meditation online mindfulness downloadable"))
    |> length == 1
  end

  test "Search - multiple results" do
    assert resources()
    |> Enum.filter(&(Search.find_matches &1, Search.split_text "community"))
    |> length == 2
  end

  test "Search - multiple word tags" do
    assert resources()
    |> Enum.filter(&(Search.find_matches &1, Search.split_text "sleep deprivation"))
    |> length == 1
  end

  test "Search - multiple word tags with stop words" do
    assert resources()
    |> Enum.filter(&(Search.find_matches &1, Search.split_text "peer to peer"))
    |> length == 1
  end
end
