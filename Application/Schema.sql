-- Your database schema. Use the Schema Designer at http://localhost:8001/ to add some tables.
CREATE TABLE users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    email TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    locked_at TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    failed_login_attempts INT DEFAULT 0 NOT NULL
);
CREATE TABLE ingredients (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL
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
ALTER TABLE group_user_maps ADD CONSTRAINT group_user_maps_ref_group_id FOREIGN KEY (group_id) REFERENCES groups (id) ON DELETE NO ACTION;
ALTER TABLE group_user_maps ADD CONSTRAINT group_user_maps_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE group_user_maps ADD CONSTRAINT group_user_maps_unique_map UNIQUE(user_id, group_id);
ALTER TABLE invitations ADD CONSTRAINT invitations_ref_group_id FOREIGN KEY (group_id) REFERENCES groups (id) ON DELETE NO ACTION;
ALTER TABLE invitations ADD CONSTRAINT invitations_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE invitations ADD CONSTRAINT invitations_ref_by_user_id FOREIGN KEY (by_user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE invitations ADD CONSTRAINT invitations_unique_user_group UNIQUE(user_id, group_id);
