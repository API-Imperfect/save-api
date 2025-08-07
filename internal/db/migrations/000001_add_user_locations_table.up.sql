CREATE TYPE "user_status" AS ENUM (
  'active',
  'inactive',
  'deleted',
  'blocked'
);

CREATE TYPE "user_prompts" AS ENUM (
  'change_password',
  'change_phone_number',
  'reset_password'
);

CREATE TABLE "users" (
  "id" bigserial PRIMARY KEY,
  "public_id" uuid NOT NULL,
  "phone_number" varchar UNIQUE NOT NULL,
  "pin" varchar NOT NULL,
  "status" user_status DEFAULT 'inactive',
  "prompt" user_prompts,
  "phone_verified" bool DEFAULT false,
  "telco" varchar NOT NULL,
  "created_at" timestamp NOT NULL DEFAULT (now()),
  "last_login" timestamp NOT NULL
);

CREATE TABLE "locations" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "province" varchar NOT NULL,
  "district" varchar NOT NULL,
  "sector" varchar NOT NULL,
  "cell" varchar NOT NULL,
  "village" varchar NOT NULL
);

CREATE INDEX ON "users" ("id");

ALTER TABLE "locations" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
