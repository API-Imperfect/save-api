-- Drop foreign key constraint first
ALTER TABLE "user_prompts" DROP CONSTRAINT IF EXISTS "user_prompts_user_id_fkey";

-- Drop index
DROP INDEX IF EXISTS "users_id_idx";

-- Drop tables (in reverse order due to foreign key dependencies)
DROP TABLE IF EXISTS "user_prompts";
DROP TABLE IF EXISTS "users";

-- Drop custom enum types
DROP TYPE IF EXISTS "user_prompt_type";
DROP TYPE IF EXISTS "user_status";
