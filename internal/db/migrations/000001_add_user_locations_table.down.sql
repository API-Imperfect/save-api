-- Drop foreign key constraint first
ALTER TABLE "users" DROP CONSTRAINT IF EXISTS "users_id_fkey";

-- Drop tables in reverse order (locations first, then users)
DROP TABLE IF EXISTS "locations";
DROP TABLE IF EXISTS "users";

-- Drop custom types in reverse order
DROP TYPE IF EXISTS "user_prompts" CASCADE;
DROP TYPE IF EXISTS "user_status" CASCADE;
