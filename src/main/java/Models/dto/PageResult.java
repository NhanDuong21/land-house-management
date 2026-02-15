package Models.dto;

import java.util.List;

/**
 * Description: DTO phan trang
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-02-15
 */
public class PageResult<T> {

    private List<T> items;
    private int page;
    private int pageSize;
    private int totalItems;
    private int totalPages;

    public PageResult() {
    }

    public PageResult(List<T> items, int page, int pageSize, int totalItems, int totalPages) {
        this.items = items;
        this.page = page;
        this.pageSize = pageSize;
        this.totalItems = totalItems;
        this.totalPages = totalPages;
    }

    public List<T> getItems() {
        return items;
    }

    public void setItems(List<T> items) {
        this.items = items;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public int getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(int totalItems) {
        this.totalItems = totalItems;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }
}
