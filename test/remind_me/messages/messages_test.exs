defmodule RemindMe.MessagesTest do
  use RemindMe.DataCase

  alias RemindMe.Messages

  describe "messages_concat" do
    alias RemindMe.Messages.MessageConcat

    @valid_attrs %{body: "some body", part: 42, ref: "some ref", to: "some to", total: 42}
    @update_attrs %{
      body: "some updated body",
      part: 43,
      ref: "some updated ref",
      to: "some updated to",
      total: 43
    }
    @invalid_attrs %{body: nil, part: nil, ref: nil, to: nil, total: nil}

    def message_concat_fixture(attrs \\ %{}) do
      {:ok, message_concat} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Messages.create_message_concat()

      message_concat
    end

    test "list_messages_concat/0 returns all messages_concat" do
      message_concat = message_concat_fixture()
      assert Messages.list_messages_concat() == [message_concat]
    end

    test "get_message_concat!/1 returns the message_concat with given id" do
      message_concat = message_concat_fixture()
      assert Messages.get_message_concat!(message_concat.id) == message_concat
    end

    test "create_message_concat/1 with valid data creates a message_concat" do
      assert {:ok, %MessageConcat{} = message_concat} =
               Messages.create_message_concat(@valid_attrs)

      assert message_concat.body == "some body"
      assert message_concat.part == 42
      assert message_concat.ref == "some ref"
      assert message_concat.to == "some to"
      assert message_concat.total == 42
    end

    test "create_message_concat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_message_concat(@invalid_attrs)
    end

    test "update_message_concat/2 with valid data updates the message_concat" do
      message_concat = message_concat_fixture()
      assert {:ok, message_concat} = Messages.update_message_concat(message_concat, @update_attrs)
      assert %MessageConcat{} = message_concat
      assert message_concat.body == "some updated body"
      assert message_concat.part == 43
      assert message_concat.ref == "some updated ref"
      assert message_concat.to == "some updated to"
      assert message_concat.total == 43
    end

    test "update_message_concat/2 with invalid data returns error changeset" do
      message_concat = message_concat_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Messages.update_message_concat(message_concat, @invalid_attrs)

      assert message_concat == Messages.get_message_concat!(message_concat.id)
    end

    test "delete_message_concat/1 deletes the message_concat" do
      message_concat = message_concat_fixture()
      assert {:ok, %MessageConcat{}} = Messages.delete_message_concat(message_concat)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_message_concat!(message_concat.id) end
    end

    test "change_message_concat/1 returns a message_concat changeset" do
      message_concat = message_concat_fixture()
      assert %Ecto.Changeset{} = Messages.change_message_concat(message_concat)
    end
  end
end
