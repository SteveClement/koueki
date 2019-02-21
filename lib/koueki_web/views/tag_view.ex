defmodule KouekiWeb.TagView do
  use KouekiWeb, :view

  def render("tag.json", %{tag: tag}) do
    %{
      name: tag.name,
      id: tag.id,
      colour: tag.colour,
      exportable: true
    }
  end

  def render("tag.wrapped.json", tag) do
    %{
      Tag: render("tag.json", tag)
    }
  end
end
