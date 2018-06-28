defmodule RemindMe.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias RemindMe.Repo

  alias RemindMe.Messages.MessageConcat

  @doc """
  Returns the list of messages_concat.

  ## Examples

      iex> list_messages_concat()
      [%MessageConcat{}, ...]

  """
  def list_messages_concat do
    Repo.all(MessageConcat)
  end

  @doc """
  Gets a single message_concat.

  Raises `Ecto.NoResultsError` if the Message concat does not exist.

  ## Examples

      iex> get_message_concat!(123)
      %MessageConcat{}

      iex> get_message_concat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message_concat!(id), do: Repo.get!(MessageConcat, id)

  @doc """
  Creates a message_concat.

  ## Examples

      iex> create_message_concat(%{field: value})
      {:ok, %MessageConcat{}}

      iex> create_message_concat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message_concat(attrs \\ %{}) do
    %MessageConcat{}
    |> MessageConcat.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message_concat.

  ## Examples

      iex> update_message_concat(message_concat, %{field: new_value})
      {:ok, %MessageConcat{}}

      iex> update_message_concat(message_concat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message_concat(%MessageConcat{} = message_concat, attrs) do
    message_concat
    |> MessageConcat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a MessageConcat.

  ## Examples

      iex> delete_message_concat(message_concat)
      {:ok, %MessageConcat{}}

      iex> delete_message_concat(message_concat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message_concat(%MessageConcat{} = message_concat) do
    Repo.delete(message_concat)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message_concat changes.

  ## Examples

      iex> change_message_concat(message_concat)
      %Ecto.Changeset{source: %MessageConcat{}}

  """
  def change_message_concat(%MessageConcat{} = message_concat) do
    MessageConcat.changeset(message_concat, %{})
  end

  def get_concat_by_ref(ref) do
    query = from(m in MessageConcat, where: m.ref == ^ref, select: m)
    Repo.all(query)
  end
end
