export interface MenuItem {
    product_id: number;
    name: string;
    image: string;
    price: number | string;
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
    duplicate?: boolean;
}
