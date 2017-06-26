defmodule App.HomepageViewTest do
  use App.ConnCase, async: true
  doctest App.HomepageView, import: true
  import App.HomepageView

    test "Number of resources - 0" do
      assert number_of_results(%{request_path: "/"}, []) == "0 resources"
    end

    test "Number of resources - 1" do
      assert number_of_results(%{request_path: "/"}, ["one"]) == "1 resource"
    end

    test "Number of resources - 2" do
      assert number_of_results(%{request_path: "/"}, ["one", "two"]) == "2 resources"
    end

    test "Number of results - 0" do
      assert number_of_results(%{request_path: "/filter"}, []) == "0 results"
    end

    test "Number of results - 1" do
      assert number_of_results(%{request_path: "/filter"}, ["one"]) == "1 result"
    end

    test "Number of results - 2" do
      assert number_of_results(%{request_path: "/filter"}, ["one", "two"]) == "2 results"
    end
end
