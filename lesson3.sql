CREATE TABLE lesson3.post (
    post_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT,
    tags TEXT[],
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_public BOOLEAN DEFAULT TRUE
);

CREATE TABLE lesson3.post_like (
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    liked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, post_id)
);

CREATE INDEX idx_post_content_lower
ON lesson3.post (LOWER(content));

CREATE INDEX idx_post_tags_gin
ON lesson3.post
USING GIN(tags);

CREATE INDEX idx_post_recent_public
ON lesson3.post(created_at DESC)
WHERE is_public = TRUE;

CREATE INDEX idx_post_user_created
ON lesson3.post(user_id, created_at DESC);