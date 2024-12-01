<script lang="ts">
    import { onMount } from 'svelte';
    import { goto } from '$app/navigation';
    import { setUser } from '$lib/auth';
    import { ApiService } from '$lib/services/api';

    interface LoginResponse {
        status: boolean;
        userId: number;
        username: string;
        role: number;
        message?: string;
    }

    let username = '';
    let password = '';
    let errorMessage = '';

    async function handleSubmit(event?: Event) {
        if (event) {
            event.preventDefault();
        }
        
        try {
            const result = await ApiService.post<LoginResponse>('login', {
                username,
                password
            });

            if (result.status) {
                await setUser({
                    userId: result.userId,
                    username: result.username,
                    role: result.role ?? 0
                });
                goto('/order');
            } else {
                errorMessage = result.message || 'Login failed';
            }
        } catch (error) {
            console.error('Login error:', error);
            errorMessage = 'Failed to login. Please try again.';
        }
    }
</script>

    <div class="flex flex-col items-center w-full px-4 pt-[20vh]">
        <div class="logo-img mx-auto mb-4 mt-8">
            <img src="/images/logo.png" class="logo w-[150px] h-[150px] md:w-[200px] md:h-[200px]" alt="Logo">
        </div>
        <div class="card bg-white/60 outline-none mb-6 border-none rounded-[20px] mt-4 pt-4 shadow-2xl w-full max-w-md mx-auto">
            <div class="card-body overflow-hidden p-5">
                <form on:submit={handleSubmit}>
                    <div class="form-group mb-3">
                        <input type="text" class="form-control form-control-sm w-full rounded-full" id="username" bind:value={username} placeholder="Username">
                    </div>
                    <div class="form-group mb-3">
                        <input type="password" class="form-control form-control-sm w-full rounded-full" id="password" bind:value={password} placeholder="Password">
                    </div>
                    <button type="submit" class="btn w-full rounded-full bg-[#47cb50] text-white py-2">Login</button>
                </form>
                <div class="account-section mt-4 text-right">
                    <a href="/register" class="new-account-link text-[#025464] font-bold text-sm">Create a new account</a>
                </div>
            </div>
        </div>
    </div>