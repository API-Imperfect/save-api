CREATE TYPE "user_status" AS ENUM (
  'active',
  'inactive',
  'deleted',
  'blocked'
);

CREATE TYPE "user_prompt_type" AS ENUM (
  'change_pin',
  'change_phone_number',
  'reset_pin'
);

CREATE TABLE "users" (
  "id" bigserial PRIMARY KEY,
  "public_id" uuid NOT NULL DEFAULT (gen_random_uuid()),
  "phone_number" varchar UNIQUE NOT NULL,
  "pin" varchar NOT NULL,
  "pin_changed_at" timestamp NOT NULL DEFAULT '0001-01-01',
  "status" user_status DEFAULT 'inactive',
  "last_prompt_action" user_prompt_type,
  "phone_verified" bool DEFAULT false,
  "telco" varchar NOT NULL,
  "created_at" timestamp NOT NULL DEFAULT (now()),
  "last_login" timestamp NOT NULL
);

CREATE TABLE "user_prompts" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "action" user_prompt_type NOT NULL,
  "performed_at" timestamp NOT NULL DEFAULT (now())
);

CREATE INDEX ON "users" ("id");

COMMENT ON COLUMN "users"."last_prompt_action" IS 'most recent user prompt';

COMMENT ON TABLE "user_prompts" IS 'Tracks all prompt-related user actions historically';

ALTER TABLE "user_prompts" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
