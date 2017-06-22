defmodule App.SearchFixtures do
  def resources do
    [
      %{
        body: "<p>guide to sleep from the NHS</p>", dislikes: 0,
        heading: "NHS Sleep Guide", id: 14, liked: "none", likes: 1, priority: 5,
        tags: %{"reason" => ["all-reason"],
          "issue" => ["insomnia", "all-issue"],
          "content" => ["all-content"]}
      },
      %{
        body: "<p>Sleepio is programme to help you sleep better. You will take a Sleep Test questionnaire and then you will be given a programme designed specifically for you. This programme will adapt as you progress through the course.</p><h5>Pros</h5><p></p><ul><li>Some free content<br/></li><li>Community </li><li>Proven to work<br/></li><li>Long-term results</li></ul><h5>Cons</h5><p></p><ul><li>Costs $300 for the full CBT course<br/></li><li>Long-term solution</li></ul>", dislikes: 0,
        heading: "Sleepio", id: 10, liked: "none", likes: 1, priority: 5,
        tags: %{"reason" => ["all-reason"],
          "issue" => ["insomnia", "all-issue"],
          "content" => ["all-content", "CBT", "app", "assessment", "community", "subscription"]}
      },
      %{
        body: "<p>A \"subreddit\" for sleep related discussion. Discussions may be based on questions related to sleep, OR on self-posted sleep related research (e.g., sleep disorders, empirically supported treatments, etc.).</p><h5>Pros</h5><p></p><ul><li>11,815 member community </li><li>Free</li><li>Wide range of advice</li><li>High levels of engagement from the community</li></ul><h5>Cons</h5><p></p><ul><li>Not fully moderated</li><li>Anecdotal content (not clinically / medically moderated)</li><li>No structured support</li><li>Not specifically London focussed </li></ul>", dislikes: 0,
        heading: "Reddit - Sleep forum", id: 17, liked: "none", likes: 1, priority: 5,
        tags: %{"reason" => ["all-reason"],
          "issue" => ["insomnia", "all-issue"],
          "content" => ["all-content"]}
      },
      %{
        body: "<p>Headspace is meditation made simple. Learn online, when you want, wherever you are, in just 10 minutes a day.</p><p>You can also use it to help you sleep better using mindfulness practice. </p><p><br/></p><p>Pros</p><p><br/></p><p>Connect with friends</p><p>Free trial </p><p>Proven to work</p><p>Covers multiple issues </p><p>Short term / emergency support available</p><p>in-browser version and downloadable app available</p><p>Cons</p><p><br/></p><p>Subscription fee for most content</p><p>Long-term solution</p>", dislikes: 0,
        heading: "Headspace", id: 9, liked: "none", likes: 1, priority: 5,
        tags: %{"reason" => ["all-reason"],
          "issue" => ["insomnia", "all-issue"],
          "content" => ["all-content", "CBT", "app", "free-trial", "mindfulness", "peer-to-peer", "subscription"]}
      }
    ]
  end
end
