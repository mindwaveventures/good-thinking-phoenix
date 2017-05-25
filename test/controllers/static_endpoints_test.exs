defmodule App.StaticEndpointsTest do
  use App.ConnCase
  alias App.Router

  test "static endpoints", %{conn: conn} do
    is_static_get? = fn route ->
      route.verb == :get && !String.contains?(route.path, "/:")
    end
    
    Router.__routes__
    |> Enum.filter_map(is_static_get?, &(&1.path))
    |> Enum.each(&(conn |> get(&1) |> html_response(200) |> assert))
  end
end
