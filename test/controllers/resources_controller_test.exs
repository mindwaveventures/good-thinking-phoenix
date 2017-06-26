defmodule App.ResourcesTest do
  use App.ConnCase, async: false
  doctest App.Resources, import: true
  import App.Resources

  test "filtering tags by topic" do
    tags = get_tags("anxiety")

    assert tags == %{
      content: ["anxiety-content"],
      issue: ["anxiety-issue-1"],
      topic: ["anxiety"],
      reason: ["anxiety-reason"]
    }
  end

  test "filtering tags by two topics" do
    tags = get_tags(["anxiety", "depression"])

    assert tags == %{
      content: ["anxiety-content", "depression-content"],
      issue: ["anxiety-issue-1", "depression-issue"],
      topic: ["anxiety", "depression"],
      reason: ["anxiety-reason", "depression-reason"]
    }
  end
end
