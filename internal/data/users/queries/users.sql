-- name: CreateUser :one
INSERT INTO users (
    phone_number,
    pin,
    pin_changed_at,
    status,
    last_prompt_action,
    phone_verified,
    telco,
    last_login
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8
) RETURNING *;

-- name: GetUserByID :one
SELECT * FROM users WHERE id = $1;

-- name: GetUserByPublicID :one
SELECT * FROM users WHERE public_id = $1;

-- name: GetUserByPhoneNumber :one
SELECT * FROM users WHERE phone_number = $1;

-- name: UpdateUserStatus :one
UPDATE users 
SET status = $2, 
    last_login = COALESCE($3, last_login)
WHERE id = $1 
RETURNING *;

-- name: UpdateUserPIN :one
UPDATE users 
SET pin = $2, 
    pin_changed_at = $3
WHERE id = $1 
RETURNING *;

-- name: UpdatePhoneVerification :one
UPDATE users 
SET phone_verified = $2
WHERE id = $1 
RETURNING *;

-- name: UpdateLastPromptAction :one
UPDATE users 
SET last_prompt_action = $2
WHERE id = $1 
RETURNING *;

-- name: UpdateLastLogin :one
UPDATE users 
SET last_login = $2
WHERE id = $1 
RETURNING *;

-- name: UpdateUserTelco :one
UPDATE users 
SET telco = $2
WHERE id = $1 
RETURNING *;

-- name: DeleteUser :exec
DELETE FROM users WHERE id = $1;

-- name: ListUsers :many
SELECT * FROM users 
ORDER BY created_at DESC;

-- name: ListUsersByStatus :many
SELECT * FROM users 
WHERE status = $1 
ORDER BY created_at DESC;

-- name: ListActiveUsers :many
SELECT * FROM users 
WHERE status = 'active' 
ORDER BY created_at DESC;

-- name: CountUsers :one
SELECT COUNT(*) FROM users;

-- name: CountUsersByStatus :one
SELECT COUNT(*) FROM users WHERE status = $1;

-- name: GetUsersByTelco :many
SELECT * FROM users 
WHERE telco = $1 
ORDER BY created_at DESC;

-- name: GetUsersByPhoneVerified :many
SELECT * FROM users 
WHERE phone_verified = $1 
ORDER BY created_at DESC;

-- name: SearchUsersByPhoneNumber :many
SELECT * FROM users 
WHERE phone_number LIKE $1 
ORDER BY created_at DESC;

-- name: GetUsersCreatedBetween :many
SELECT * FROM users 
WHERE created_at BETWEEN $1 AND $2 
ORDER BY created_at DESC;

-- name: GetUsersByLastLoginRange :many
SELECT * FROM users 
WHERE last_login BETWEEN $1 AND $2 
ORDER BY last_login DESC;

-- name: GetUsersByPINChangedAfter :many
SELECT * FROM users 
WHERE pin_changed_at > $1 
ORDER BY pin_changed_at DESC;

-- name: UpdateUserComprehensive :one
UPDATE users 
SET 
    phone_number = COALESCE($2, phone_number),
    pin = COALESCE($3, pin),
    pin_changed_at = COALESCE($4, pin_changed_at),
    status = COALESCE($5, status),
    last_prompt_action = COALESCE($6, last_prompt_action),
    phone_verified = COALESCE($7, phone_verified),
    telco = COALESCE($8, telco),
    last_login = COALESCE($9, last_login)
WHERE id = $1 
RETURNING *;

-- name: GetUserWithPrompts :many
SELECT 
    u.*,
    up.id as prompt_id,
    up.action as prompt_action,
    up.performed_at as prompt_performed_at
FROM users u
LEFT JOIN user_prompts up ON u.id = up.user_id
WHERE u.id = $1
ORDER BY up.performed_at DESC;

-- name: CreateUserPrompt :one
INSERT INTO user_prompts (
    user_id,
    action
) VALUES (
    $1, $2
) RETURNING *;

-- name: GetUserPrompts :many
SELECT * FROM user_prompts 
WHERE user_id = $1 
ORDER BY performed_at DESC;

-- name: GetUserPromptsByAction :many
SELECT * FROM user_prompts 
WHERE user_id = $1 AND action = $2 
ORDER BY performed_at DESC;

-- name: GetRecentUserPrompts :many
SELECT * FROM user_prompts 
WHERE user_id = $1 
ORDER BY performed_at DESC 
LIMIT $2;
