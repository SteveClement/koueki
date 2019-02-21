defmodule Koueki.Tag do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  alias Koueki.{
    Tag,
    Repo
  }

  schema "tags" do
    field :uuid, Ecto.UUID, autogenerate: true
    field :name, :string
    field :colour, :string, default: "#FFFFFF"

    many_to_many :events, Koueki.Event, join_through: "event_tags"
    many_to_many :attributes, Koueki.Attribute, join_through: "attribute_tags"
  end

  defp find_by_id_or_name(params) do
    id = Map.get(params, "id", 0)
    name = Map.get(params, "name", "")

    Repo.one(
      from tag in Tag,
      where: tag.id == ^id or tag.name == ^name
    )
  end

  def find_or_create(%{} = params) do
    with %Tag{} = tag <- find_by_id_or_name(params) do
      tag
    else
      _ -> 
        %Tag{}
        |> cast(params, [:name, :colour])
        |> validate_required([:name])
        |> validate_format(:colour, ~r/#[0-9A-Fa-f]{6}/)
        |> validate_length(:name, min: 1)
        |> unique_constraint(:name)
    end
  end

  def find_or_create(params) when is_list(params) do
    Enum.map(params, fn x -> find_or_create(x) end)
  end
end
