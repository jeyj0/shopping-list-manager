-- Your database schema. Use the Schema Designer at http://localhost:8001/ to add some tables.
CREATE TABLE users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    email TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    locked_at TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    failed_login_attempts INT DEFAULT 0 NOT NULL
);
CREATE TABLE ingredients (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    group_id UUID NOT NULL,
    name TEXT NOT NULL UNIQUE
);
CREATE TABLE groups (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    name TEXT NOT NULL
);
CREATE TABLE group_user_maps (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    user_id UUID NOT NULL,
    group_id UUID NOT NULL
);
CREATE INDEX group_user_maps_map_ids ON group_user_maps (user_id, group_id);
CREATE INDEX group_user_maps_user_id ON group_user_maps (user_id);
CREATE INDEX group_user_maps_group_id ON group_user_maps (group_id);
CREATE TABLE invitations (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    user_id UUID NOT NULL,
    group_id UUID NOT NULL,
    by_user_id UUID DEFAULT uuid_generate_v4() NOT NULL
);
CREATE INDEX invitations_user_id ON invitations (user_id);
CREATE INDEX invitations_group_id ON invitations (group_id);
CREATE INDEX invitations_by_user_id ON invitations (by_user_id);
CREATE INDEX invitations_group_id__by_user_id ON invitations (group_id, by_user_id);
CREATE TABLE recipes (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    group_id UUID NOT NULL,
    name TEXT NOT NULL
);
CREATE INDEX recipes_group_id_idx ON recipes (group_id);
CREATE TABLE recipe_ingredients (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    ingredient_id UUID NOT NULL,
    recipe_id UUID NOT NULL
);
CREATE INDEX recipe_ingredients_recipe_id ON recipe_ingredients (recipe_id);
CREATE TABLE eating_plans (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    group_id UUID NOT NULL,
    name TEXT NOT NULL
);
CREATE TABLE eating_plan_recipes (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    eating_plan_id UUID NOT NULL,
    recipe_id UUID NOT NULL
);
CREATE TABLE shopping_lists (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    group_id UUID NOT NULL
);
ALTER TABLE eating_plan_recipes ADD CONSTRAINT eating_plan_recipes_ref_eating_plan_id FOREIGN KEY (eating_plan_id) REFERENCES eating_plans (id) ON DELETE NO ACTION;
ALTER TABLE eating_plan_recipes ADD CONSTRAINT eating_plan_recipes_ref_recipe_id FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE NO ACTION;
ALTER TABLE eating_plans ADD CONSTRAINT eating_plans_ref_group_id FOREIGN KEY (group_id) REFERENCES groups (id) ON DELETE NO ACTION;
ALTER TABLE eating_plans ADD CONSTRAINT eating_plans_unique_name_in_group UNIQUE(group_id, name);
ALTER TABLE group_user_maps ADD CONSTRAINT group_user_maps_ref_group_id FOREIGN KEY (group_id) REFERENCES groups (id) ON DELETE NO ACTION;
ALTER TABLE group_user_maps ADD CONSTRAINT group_user_maps_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE group_user_maps ADD CONSTRAINT group_user_maps_unique_map UNIQUE(user_id, group_id);
ALTER TABLE ingredients ADD CONSTRAINT ingredients_ref_group_id FOREIGN KEY (group_id) REFERENCES groups (id) ON DELETE NO ACTION;
ALTER TABLE invitations ADD CONSTRAINT invitations_ref_by_user_id FOREIGN KEY (by_user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE invitations ADD CONSTRAINT invitations_ref_group_id FOREIGN KEY (group_id) REFERENCES groups (id) ON DELETE NO ACTION;
ALTER TABLE invitations ADD CONSTRAINT invitations_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE invitations ADD CONSTRAINT invitations_unique_user_group UNIQUE(user_id, group_id);
ALTER TABLE recipe_ingredients ADD CONSTRAINT recipe_ingredients_ref_ingredient_id FOREIGN KEY (ingredient_id) REFERENCES ingredients (id) ON DELETE NO ACTION;
ALTER TABLE recipe_ingredients ADD CONSTRAINT recipe_ingredients_ref_recipe_id FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE NO ACTION;
ALTER TABLE recipe_ingredients ADD CONSTRAINT recipe_ingredients_unique_map UNIQUE(ingredient_id, recipe_id);
ALTER TABLE recipes ADD CONSTRAINT recipes_ref_group_id FOREIGN KEY (group_id) REFERENCES groups (id) ON DELETE NO ACTION;
ALTER TABLE recipes ADD CONSTRAINT recipes_unique_name_in_group UNIQUE(group_id, name);
ALTER TABLE shopping_lists ADD CONSTRAINT shopping_lists_ref_group_id FOREIGN KEY (group_id) REFERENCES groups (id) ON DELETE NO ACTION;
