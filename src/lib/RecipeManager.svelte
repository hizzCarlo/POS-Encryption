<script lang="ts">
    import { onMount } from 'svelte';
    
    type Ingredient = {
      inventory_id: number;
      item_name: string;
      stock_quantity: number;
      unit_of_measure: string;
    };
  
    type Recipe = {
      product_ingredient_id?: number;
      inventory_id: number;
      ingredient_name: string;
      quantity_needed: number;
      unit_of_measure: string;
      stock_quantity: number;
    };
  
    export let productId: number;
    export let productName: string;
  
    let ingredients: Ingredient[] = [];
    let productRecipe: Recipe[] = [];
    let newIngredient = {
      inventory_id: 0,
      quantity_needed: 0,
      unit_of_measure: ''
    };
  
    let editingIngredient: number | null = null;
    let editQuantity: number = 0;
  
    let searchIngredient = '';
    let searchRecipe = '';
  
    $: filteredIngredients = ingredients.filter(ingredient => 
      ingredient.item_name.toLowerCase().includes(searchIngredient.toLowerCase())
    );
  
    $: filteredRecipe = productRecipe.filter(ingredient => 
      ingredient.ingredient_name.toLowerCase().includes(searchRecipe.toLowerCase())
    );
  
    onMount(async () => {
      await Promise.all([
        fetchIngredients(),
        fetchProductRecipe()
      ]);
    });
  
    async function fetchIngredients() {
      const response = await fetch('/api/get-items');
      const result = await response.json();
      if (result.status) {
        ingredients = result.data;
      }
    }
  
    async function fetchProductRecipe() {
      const response = await fetch(`/api/get-product-ingredients&product_id=${productId}`);
      const result = await response.json();
      if (result.status) {
        productRecipe = result.data;
      }
    }
  
    async function addIngredient() {
      if (!newIngredient.inventory_id || !newIngredient.quantity_needed) {
        alert('Please select an ingredient and specify quantity');
        return;
      }
  
      try {
        const response = await fetch('/api/add-product-ingredient', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            product_id: productId,
            inventory_id: newIngredient.inventory_id,
            quantity_needed: newIngredient.quantity_needed,
            unit_of_measure: selectedIngredient?.unit_of_measure || 'pieces'
          })
        });
  
        const result = await response.json();
        if (result.status) {
          await fetchProductRecipe();
          newIngredient = {
            inventory_id: 0,
            quantity_needed: 0,
            unit_of_measure: ''
          };
        } else {
          alert(result.message);
        }
      } catch (error) {
        console.error('Error:', error);
        alert('Failed to add ingredient');
      }
    }
  
    async function removeIngredient(ingredientId: number) {
      if (!confirm('Are you sure you want to remove this ingredient?')) return;
  
      const response = await fetch('/api/delete-product-ingredient', {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          product_ingredient_id: ingredientId
        })
      });
  
      const result = await response.json();
      if (result.status) {
        await fetchProductRecipe();
      } else {
        alert(result.message);
      }
    }
  
    async function updateIngredientQuantity(ingredient: Recipe) {
      const response = await fetch('/api/update-product-ingredient', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          product_ingredient_id: ingredient.product_ingredient_id,
          quantity_needed: editQuantity,
          unit_of_measure: editUnitOfMeasure
        })
      });
  
      const result = await response.json();
      if (result.status) {
        await fetchProductRecipe();
        editingIngredient = null;
      } else {
        alert(result.message);
      }
    }
  
    $: selectedIngredient = ingredients.find(i => i.inventory_id === newIngredient.inventory_id);
    $: if (selectedIngredient) {
      newIngredient.unit_of_measure = selectedIngredient.unit_of_measure;
    }
  
    type UnitOfMeasure = 'pieces' | 'grams' | 'kilograms' | 'milliliters' | 'liters' | 'cups' | 'tablespoons' | 'teaspoons';
  
    const unitOptions: UnitOfMeasure[] = ['pieces', 'grams', 'kilograms', 'milliliters', 'liters', 'cups', 'tablespoons', 'teaspoons'];
  
    let editUnitOfMeasure: UnitOfMeasure = 'pieces';
  </script>
  
  <div class="recipe-manager">
    <h2 class="text-xl font-bold mb-4">Recipe Management - {productName}</h2>
  
    <div class="recipe-container">
      <!-- Add Ingredient Section -->
      <div class="add-ingredient-section">
        <h3 class="text-lg font-semibold mb-2">Add Ingredient</h3>
        <div class="grid grid-cols-1 gap-2">
          <input 
            type="text"
            bind:value={searchIngredient}
            placeholder="Search ingredients..."
            class="p-2 border rounded-md w-full"
          />
          <select 
            bind:value={newIngredient.inventory_id}
            class="p-2 border rounded-md w-full"
          >
            <option value={0}>Select Ingredient</option>
            {#each filteredIngredients as ingredient}
              <option value={ingredient.inventory_id}>
                {ingredient.item_name} ({ingredient.stock_quantity} {ingredient.unit_of_measure})
              </option>
            {/each}
          </select>
          
          <div class="flex gap-2">
            <input 
              type="number" 
              bind:value={newIngredient.quantity_needed}
              placeholder="Quantity needed"
              class="p-2 border rounded-md flex-1"
              min="0"
              step="0.01"
            />
            <select 
              bind:value={newIngredient.unit_of_measure}
              class="p-2 border rounded-md"
            >
              {#each unitOptions as unit}
                <option value={unit}>{unit}</option>
              {/each}
            </select>
            <button 
              on:click={addIngredient}
              class="bg-green-500 text-white px-4 py-2 rounded-md whitespace-nowrap"
            >
              Add
            </button>
          </div>
        </div>
      </div>
  
      <!-- Recipe List Section -->
      <div class="recipe-list-section">
        <div class="sticky top-0 bg-white py-2 space-y-2">
          <h3 class="text-lg font-semibold">Current Recipe</h3>
          <input 
            type="text"
            bind:value={searchRecipe}
            placeholder="Search recipe ingredients..."
            class="p-2 border rounded-md w-full"
          />
        </div>
        <div class="recipe-table-container">
          {#if filteredRecipe.length === 0}
            {#if searchRecipe && productRecipe.length > 0}
              <p class="text-gray-500">No matching ingredients found</p>
            {:else}
              <p class="text-gray-500">No ingredients added yet</p>
            {/if}
          {:else}
            <table class="w-full">
              <thead class="sticky top-0 bg-white">
                <tr>
                  <th class="text-left py-2">Ingredient</th>
                  <th class="text-left py-2">Qty</th>
                  <th class="text-left py-2">Unit</th>
                  <th class="text-left py-2">Stock</th>
                  <th class="text-center py-2">Actions</th>
                </tr>
              </thead>
              <tbody>
                {#each filteredRecipe as ingredient}
                  <tr class="border-t">
                    <td class="py-2">{ingredient.ingredient_name}</td>
                    <td class="py-2">
                      {#if editingIngredient === ingredient.product_ingredient_id}
                        <div class="flex gap-2 items-center">
                          <input 
                            type="number" 
                            bind:value={editQuantity}
                            class="p-2 border rounded w-20"
                            min="0"
                            step="0.01"
                          />
                          <select 
                            bind:value={editUnitOfMeasure}
                            class="p-2 border rounded"
                          >
                            {#each unitOptions as unit}
                              <option value={unit}>{unit}</option>
                            {/each}
                          </select>
                          <button 
                            on:click={() => updateIngredientQuantity(ingredient)}
                            class="text-green-500 hover:text-green-700"
                          >
                            Save
                          </button>
                          <button 
                            on:click={() => editingIngredient = null}
                            class="text-gray-500 hover:text-gray-700"
                          >
                            Cancel
                          </button>
                        </div>
                      {:else}
                        {ingredient.quantity_needed}
                      {/if}
                    </td>
                    <td class="py-2">{ingredient.unit_of_measure}</td>
                    <td class="py-2">{ingredient.stock_quantity}</td>
                    <td class="py-2 flex justify-center gap-2">
                      <button
                        on:click={() => {
                          editingIngredient = ingredient.product_ingredient_id;
                          editQuantity = ingredient.quantity_needed;
                          editUnitOfMeasure = ingredient.unit_of_measure as UnitOfMeasure;
                        }}
                        class="text-blue-500 hover:text-blue-700"
                      >
                        Edit
                      </button>
                      <button
                        on:click={() => removeIngredient(ingredient.product_ingredient_id)}
                        class="text-red-500 hover:text-red-700"
                      >
                        Remove
                      </button>
                    </td>
                  </tr>
                {/each}
              </tbody>
            </table>
          {/if}
        </div>
      </div>
    </div>
  </div>
  
  <style>
    .recipe-manager {
      background: white;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      height: 100%;
      max-height: 80vh;
      display: flex;
      flex-direction: column;
    }
  
    .recipe-container {
      display: grid;
      grid-template-rows: auto 1fr;
      gap: 1rem;
      padding: 1rem;
      height: 100%;
      overflow: hidden;
    }
  
    .add-ingredient-section {
      background: #f8f9fa;
      padding: 1rem;
      border-radius: 6px;
    }
  
    .recipe-list-section {
      display: flex;
      flex-direction: column;
      min-height: 0;
    }
  
    .recipe-table-container {
      overflow-y: auto;
      border: 1px solid #eee;
      border-radius: 4px;
      padding: 0.5rem;
      flex: 1;
    }
  
    table {
      border-collapse: collapse;
      width: 100%;
    }
  
    th {
      background: white;
      z-index: 10;
    }
  
    tr:hover {
      background-color: #f8f9fa;
    }
  
    @media (max-width: 640px) {
      .recipe-manager {
        max-height: 90vh;
      }
  
      .recipe-container {
        padding: 0.5rem;
        gap: 0.5rem;
      }
  
      table {
        font-size: 0.875rem;
      }
  
      th, td {
        padding: 0.25rem;
      }
    }
  </style>