-- Drop foreign key constraint first
ALTER TABLE "profiles" DROP CONSTRAINT IF EXISTS "profiles_user_id_fkey";

-- Drop table
DROP TABLE IF EXISTS "profiles";

-- Drop custom types in reverse order
DROP TYPE IF EXISTS "profile_languages" CASCADE;
DROP TYPE IF EXISTS "profile_marital_status" CASCADE;
DROP TYPE IF EXISTS "profile_education_levels" CASCADE;
DROP TYPE IF EXISTS "profile_genders" CASCADE;
