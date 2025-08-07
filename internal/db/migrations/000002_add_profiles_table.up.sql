
CREATE TYPE "profile_genders" AS ENUM (
  'male',
  'female'
);

CREATE TYPE "profile_education_levels" AS ENUM (
  'primary',
  'secondary',
  'university',
  'tertiary'
);

CREATE TYPE "profile_marital_status" AS ENUM (
  'single',
  'married',
  'divorced',
  'widowed'
);

CREATE TYPE "profile_languages" AS ENUM (
  'en',
  'rw'
);



CREATE TABLE "profiles" (
  "id" bigserial PRIMARY KEY,
  "public_id" uuid NOT NULL,
  "user_id" bigint NOT NULL UNIQUE,
  "first_name" varchar NOT NULL,
  "middle_name" varchar,
  "last_name" varchar NOT NULL,
  "birth_date" date NOT NULL,
  "id_number" varchar NOT NULL,
  "email" varchar,
  "country" varchar NOT NULL,
  "work_email" varchar,
  "gender" profile_genders DEFAULT 'male',
  "avatar" varchar,
  "next_of_kin_names" varchar,
  "next_of_kin_relationship" varchar,
  "next_of_kin_phone_number" varchar,
  "occupation" varchar NOT NULL,
  "employment_status" varchar,
  "education_level" profile_education_levels DEFAULT 'primary',
  "marital_status" profile_marital_status DEFAULT 'single',
  "language" profile_languages DEFAULT 'en',
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE INDEX ON "profiles" ("id"); 

COMMENT ON COLUMN "profiles"."updated_at" IS 'Auto-update on row change';

ALTER TABLE "profiles" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
