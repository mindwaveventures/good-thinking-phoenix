defmodule App.SpreadsheetControllerTest do
  use App.ConnCase, async: false
  doctest App.SpreadsheetController, import: true

  @flashes [
    emails: {%{"email" => %{"email" => "test@me.com"}},
             "Email address entered successfully"},
    emails_error: {%{"email" => %{"email" => "test@me"}},
                   "Please enter a valid email address"},
    emails_error: {%{"email" => %{"email" => "test"}},
                   "Please enter a valid email address"},
    suggestions: {%{"suggestions" => %{"suggestions" => "suggestion"}},
                  "Thank you for your input, "},
    suggestions_error: {%{"suggestions" => %{"suggestions" => ""}},
                        "Please enter a suggestion"},
    feedback_error: {%{"feedback" => %{"email" => "",
                                       "feedback1" => "",
                                       "feedback2" => ""}},
                       "Please ensure you have filled in some of the fields"},
    feedback_error: {%{"feedback" => %{"email" => "",
                                 "feedback1" => "",
                                 "feedback2" => "",
                                 "question1" => ""}},
                       "Please ensure you have filled in some of the fields"},
    feedback_error: {%{"feedback" => %{"email" => "email",
                                       "feedback1" => "",
                                       "feedback2" => ""}},
                       "Please enter a valid email address"},
    feedback: {%{"feedback" => %{"email" => "",
                                 "feedback1" => "",
                                 "feedback2" => "",
                                 "question1" => "Satisfied"}},
                 "Thanks for your feedback"},
  ]

  def other_flash(flash_atom) do
    flash_string = Atom.to_string flash_atom
    case String.ends_with? flash_string, "_error" do
      true -> String.replace_suffix flash_string, "_error", ""
      false -> flash_string <> "_error"
    end |> String.to_atom
  end

  test "submition of feedback", %{conn: conn} do
    @flashes |> Enum.each(fn {flash_atom, {params, flash_message}} ->
      conn = post conn, feedback_path(conn, :post, params)
      refute get_flash(conn, other_flash(flash_atom))
      assert get_flash(conn, flash_atom) =~ flash_message
      assert html_response(conn, 302)
    end)
  end
end
