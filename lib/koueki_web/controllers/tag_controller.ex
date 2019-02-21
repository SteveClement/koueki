defmodule KouekiWeb.TagController do
  use KouekiWeb, :controller

  alias KouekiWeb.{
    Status,
    TagView
  }

  alias Koueki.{
    Tag,
    Repo
  }

  def view(conn, %{"id" => id}, render_as \\ "tag.json") do
    with %Tag{} = tag <- Repo.get(Tag, id) do
      conn
      |> json(TagView.render(render_as, %{tag: tag}))
    else
      _ -> Status.not_found(conn, "Tag #{id} not found")
    end
  end

  def create(conn, params, render_as \\ "tag.json") do
    tag = Tag.changeset(%Tag{}, params)

    if tag.valid? do
      with {:ok, tag} <- Repo.insert(tag) do
        conn
        |> put_status(201)
        |> json(TagView.render(render_as, %{tag: tag}))
      else
        err -> Status.internal_error(conn, "Something happened when inserting a tag")
      end
    else
      Status.validation_error(conn, tag)
    end
  end

end