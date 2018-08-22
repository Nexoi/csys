defmodule CSysWeb.TermView do
  use CSysWeb, :view

  def render("terms.json", %{terms: terms}) do
    %{data: render_many(terms, CSysWeb.TermView, "term.json")}
  end

  def render("term.json", %{term: term}) do
    %{
      term: term.term,
      term_id: term.id,
      term_name: term.name
    }
  end

end
