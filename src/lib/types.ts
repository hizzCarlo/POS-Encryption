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

export interface ProductIngredient {
    product_name: string;
    category: string;
    quantity_needed: number;
    unit_of_measure: string;
    product_ingredient_id: number;
}

export interface ProductIngredientResponse {
    status: boolean;
    data: ProductIngredient[];
    message?: string;
}

export type AlertType = 'success' | 'error' | 'warning';

export interface BatchAvailabilityResponse {
    status: boolean;
    data: Record<number, {
        isAvailable: boolean;
        ingredients: Array<{
            product_id: number;
            quantity_needed: number;
            stock_quantity: number;
            unit_of_measure: string;
        }>;
    }>;
}
