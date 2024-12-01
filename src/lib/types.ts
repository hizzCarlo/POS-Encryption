export interface MenuItem {
    product_id: number;
    name: string;
    image: string | File;
    price: number;
    category: string;
    size?: string;
}

export interface MenuItemResponse {
    status: boolean;
    data: MenuItem[];
    message?: string;
}

export interface ApiResponse<T> {
    status: boolean;
    data?: T;
    message?: string;
}
