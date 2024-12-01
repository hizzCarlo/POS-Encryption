<script lang="ts">
    import { goto } from '$app/navigation';
    import { encryptionService } from '$lib/services/encryption';

    let username = '';
    let password = '';

    async function register() {
        try {
            const encryptedData = await encryptionService.encrypt({
                username,
                password
            });

            console.log('Sending encrypted data:', encryptedData);

            const response = await fetch('/api/add-account', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ data: encryptedData })
            });

            const contentType = response.headers.get('content-type');
            if (contentType && contentType.includes('application/json')) {
                const text = await response.text();
                console.log('Response text:', text);

                const result = JSON.parse(text);
                
                const decryptedResult = result.data ? 
                    await encryptionService.decrypt(result.data) : 
                    result;

                console.log('Decrypted result:', decryptedResult);

                if (decryptedResult.status) {
                    alert('Registration successful');
                    goto('/');
                } else {
                    alert(decryptedResult.message || 'Registration failed');
                }
            } else {
                const text = await response.text();
                console.error('Unexpected response:', text);
                throw new Error('Invalid JSON response');
            }
        } catch (error) {
            console.error('Error during registration:', error);
            alert('An error occurred. Please try again.');
        }
    }
</script>

<div class="flex flex-col items-center w-full px-4 pt-[20vh]">
    <div class="logo-img mx-auto mb-4 mt-8">
        <img src="/images/logo.png" class="logo w-[150px] h-[150px] md:w-[200px] md:h-[200px]" alt="Logo">
    </div>
    <div class="card bg-white/60 outline-none mb-6 border-none rounded-[20px] mt-4 pt-4 shadow-2xl w-full max-w-md mx-auto">
        <div class="card-body overflow-hidden p-5">
            <form on:submit|preventDefault={register}>
                <div class="form-group mb-3">
                    <input 
                        type="text" 
                        class="form-control form-control-sm w-full rounded-full" 
                        id="username" 
                        bind:value={username} 
                        placeholder="Create Username"
                        required
                    >
                </div>
                <div class="form-group mb-3">
                    <input 
                        type="password" 
                        class="form-control form-control-sm w-full rounded-full" 
                        id="password" 
                        bind:value={password} 
                        placeholder="Put Password"
                        required
                    >
                </div>
                <button 
                    type="submit" 
                    class="btn w-full rounded-full bg-[#41b745] text-white py-2 hover:bg-[#3aa03e] transition-colors"
                    disabled={!username || !password}
                >
                    Create
                </button>
            </form>
            <div class="account-section mt-4 text-right">
                <a href="/" class="new-account-link text-[#025464] font-bold text-sm hover:text-[#013744] transition-colors">
                    Back to Login
                </a>
            </div>
        </div>
    </div>
</div>

<style>
    .form-control:focus {
        outline: none;
        box-shadow: 0 0 0 2px rgba(65, 183, 69, 0.2);
        border-color: #41b745;
    }

    .form-control {
        transition: all 0.2s ease-in-out;
        border: 1px solid #e2e8f0;
        padding: 0.5rem 1rem;
    }

    .btn:disabled {
        background-color: #9ca3af;
        cursor: not-allowed;
    }
</style>