import { encryptionService } from './encryption.js';
import { userStore } from '../auth.js';
import { get } from 'svelte/store';

export class ApiService {
    static async post<T>(endpoint: string, data: unknown): Promise<T> {
        try {
            const encryptedData = await encryptionService.encrypt(data);
            const user = get(userStore);
            
            const response = await fetch(`/api/${endpoint}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${user.userId}`
                },
                body: JSON.stringify({ data: encryptedData })
            });

            if (response.status === 401) {
                // Handle unauthorized access
                userStore.clear();
                window.location.href = '/';
                throw new Error('Unauthorized');
            }

            const result = await response.json();
            if (result.data) {
                return await encryptionService.decrypt(result.data) as T;
            }
            return result as T;
        } catch (error) {
            console.error(`API Error (${endpoint}):`, error);
            throw error;
        }
    }

    static async get<T>(endpoint: string, params?: Record<string, string>): Promise<T> {
        try {
            const user = get(userStore);
            const queryString = params ? 
                '?' + new URLSearchParams(params).toString() : '';
            
            const response = await fetch(`/api/${endpoint}${queryString}`, {
                headers: {
                    'Authorization': `Bearer ${user.userId}`
                }
            });

            if (response.status === 401) {
                userStore.clear();
                window.location.href = '/';
                throw new Error('Unauthorized');
            }

            const result = await response.json();
            if (result.data) {
                return await encryptionService.decrypt(result.data) as T;
            }
            return result as T;
        } catch (error) {
            console.error(`API Error (${endpoint}):`, error);
            throw error;
        }
    }
} 