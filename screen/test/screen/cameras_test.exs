defmodule Screen.CamerasTest do
  use Screen.DataCase

  alias Screen.Cameras

  describe "cameras" do
    alias Screen.Cameras.Camera

    import Screen.CamerasFixtures

    @invalid_attrs %{last_seen: nil, name: nil}

    test "checkin/1 will create a new camera if it hasn't been seen before" do
      %Camera{} = camera = Cameras.checkin("foo")
      assert camera.name == "foo"
      assert %DateTime{} = camera.last_seen

      assert %Camera{} = Cameras.get_camera!("foo")
    end

    test "checkin/1 will update the last_seen timestamp on an existing camera" do
      camera = camera_fixture()
      camera2 = Cameras.checkin(camera.name)
      assert camera.name == camera2.name
      assert DateTime.compare(camera2.last_seen, camera.last_seen) == :gt
      camera3 = Cameras.get_camera!(camera.name)
      assert camera3.last_seen == camera2.last_seen
      assert camera3.name == camera.name
    end

    test "list_cameras/0 returns all cameras" do
      camera = camera_fixture()
      assert Cameras.list_cameras() == [camera]
    end

    test "get_camera!/1 returns the camera with given name" do
      camera = camera_fixture()
      assert Cameras.get_camera!(camera.name) == camera
    end

    test "create_camera/1 with valid data creates a camera" do
      valid_attrs = %{last_seen: ~U[2022-03-11 16:20:00Z], name: "some name"}

      assert {:ok, %Camera{} = camera} = Cameras.create_camera(valid_attrs)
      assert camera.last_seen == ~U[2022-03-11 16:20:00.000000Z]
      assert camera.name == "some name"
    end

    test "create_camera/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cameras.create_camera(@invalid_attrs)
    end

    test "update_camera/2 with valid data updates the camera" do
      camera = camera_fixture()
      update_attrs = %{last_seen: ~U[2022-03-12 16:20:00Z]}

      assert {:ok, %Camera{} = camera} = Cameras.update_camera(camera, update_attrs)
      assert camera.last_seen == ~U[2022-03-12 16:20:00.000000Z]
      assert camera.name == camera.name
    end

    test "update_camera/2 with invalid data returns error changeset" do
      camera = camera_fixture()
      assert {:error, %Ecto.Changeset{}} = Cameras.update_camera(camera, @invalid_attrs)
      assert camera == Cameras.get_camera!(camera.name)
    end

    test "delete_camera/1 deletes the camera" do
      camera = camera_fixture()
      assert {:ok, %Camera{}} = Cameras.delete_camera(camera)
      assert_raise Ecto.NoResultsError, fn -> Cameras.get_camera!(camera.name) end
    end

    test "change_camera/1 returns a camera changeset" do
      camera = camera_fixture()
      assert %Ecto.Changeset{} = Cameras.change_camera(camera)
    end
  end

  describe "clips" do
    alias Screen.Cameras.Clip

    import Screen.CamerasFixtures

    @invalid_attrs %{timestamp: nil}

    test "get_clip!/1 returns the clip with given id" do
      camera = camera_fixture()
      clip = clip_fixture(camera)
      assert Cameras.get_clip!(clip.id) == clip
    end

    test "create_clip/1 with valid data creates a clip" do
      camera = camera_fixture()
      valid_attrs = %{timestamp: 42}

      assert {:ok, %Clip{} = clip} = Cameras.create_clip(camera, valid_attrs)
      assert clip.timestamp == 42
    end

    test "create_clip/1 with invalid data returns error changeset" do
      camera = camera_fixture()
      assert {:error, %Ecto.Changeset{}} = Cameras.create_clip(camera, @invalid_attrs)
    end
  end
end
