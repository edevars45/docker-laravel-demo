<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class CreateAdminUserSeeder extends Seeder
{
    public function run(): void
    {
        // Vérifie si l'user existe déjà
        $user = User::where('email', 'devarsesther@gmail.com')->first();

        if (!$user) {
            $user = User::create([
                'name' => 'Esther Devars',
                'email' => 'devarsesther@gmail.com',
                'password' => Hash::make('123456789'),
            ]);
        }

        // Attribue le rôle admin
        if (!$user->hasRole('admin')) {
            $user->assignRole('admin');
        }
    }
}
