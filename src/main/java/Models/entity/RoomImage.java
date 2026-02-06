package Models.entity;

public class RoomImage {

    private int imageId;
    private int roomId;
    private String imageUrl;
    private boolean cover;
    private int sortOrder;

    public RoomImage() {
    }

    public RoomImage(int imageId, int roomId, String imageUrl, boolean cover, int sortOrder) {
        this.imageId = imageId;
        this.roomId = roomId;
        this.imageUrl = imageUrl;
        this.cover = cover;
        this.sortOrder = sortOrder;
    }

    public int getImageId() {
        return imageId;
    }

    public void setImageId(int imageId) {
        this.imageId = imageId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isCover() {
        return cover;
    }

    public void setCover(boolean cover) {
        this.cover = cover;
    }

    public int getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(int sortOrder) {
        this.sortOrder = sortOrder;
    }

}
