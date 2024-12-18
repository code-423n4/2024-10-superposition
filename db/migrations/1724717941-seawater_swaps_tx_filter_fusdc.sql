-- migrate:up

-- Exactly like seawater_swaps_user_2 and seawater_swaps_pool_2, except we filter for
-- fUSDC as the other token.

CREATE FUNCTION seawater_swaps_user_3(
	fusdcAddress ADDRESS,
	fusdcDecimals HUGEINT,
	owner ADDRESS,
	after TIMESTAMP,
	limit_ INTEGER
)
RETURNS SETOF seawater_swaps_3_return
LANGUAGE SQL
STABLE
AS
$$
SELECT
	swaps.created_by,
	swaps.sender,
	swaps.token_in,
	swaps.token_out,
	swaps.amount_in,
	swaps.amount_out,
	swaps.transaction_hash,
	COALESCE(toPool.decimals, fusdcDecimals) AS token_out_decimals,
	COALESCE(fromPool.decimals, fusdcDecimals) AS token_in_decimals
FROM (
	(
		SELECT
			created_by,
			user_ AS sender,
			from_ AS token_in,
			to_ AS token_out,
			amount_in,
			amount_out,
			transaction_hash
		FROM
			events_seawater_swap2
		WHERE created_by > after AND user_ = owner
		ORDER BY created_by DESC
		LIMIT limit_
	)
	UNION ALL
	(
		SELECT
			created_by,
			user_ AS sender,
			CASE
				WHEN zero_for_one THEN pool
				ELSE fusdcAddress
			END AS from,
			CASE
				WHEN zero_for_one THEN fusdcAddress
				ELSE pool
			END AS to,
			CASE
				WHEN zero_for_one THEN amount0
				ELSE amount1
			END AS amount_in,
			CASE
				WHEN zero_for_one THEN amount1
				ELSE amount0
			END AS amount_out,
			transaction_hash
		FROM
			events_seawater_swap1
		WHERE created_by > after AND user_ = owner
		ORDER BY created_by DESC
		LIMIT limit_
	)
) swaps
LEFT JOIN events_seawater_newpool fromPool
	ON swaps.token_in = fromPool.token
LEFT JOIN events_seawater_newpool toPool
	ON swaps.token_out = toPool.token;
$$;

CREATE FUNCTION seawater_swaps_pool_3(
	fusdcAddress ADDRESS,
	fusdcDecimals HUGEINT,
	filter ADDRESS,
	after TIMESTAMP,
	limit_ INTEGER
)
RETURNS SETOF seawater_swaps_3_return
LANGUAGE SQL
STABLE
AS
$$
SELECT
	swaps.created_by,
	swaps.sender,
	swaps.token_in,
	swaps.token_out,
	swaps.amount_in,
	swaps.amount_out,
	swaps.transaction_hash,
	COALESCE(toPool.decimals, fusdcDecimals) AS token_out_decimals,
	COALESCE(fromPool.decimals, fusdcDecimals) AS token_in_decimals
FROM (
	(
		SELECT
			created_by,
			user_ AS sender,
			from_ AS token_in,
			to_ AS token_out,
			amount_in,
			amount_out,
			transaction_hash
		FROM
			events_seawater_swap2
		WHERE created_by > after AND (from_ = filter OR to_ = filter) AND (from_ = fusdcAddress OR to_ = fusdcAddress)
		ORDER BY created_by DESC
		LIMIT limit_
	)
	UNION ALL
	(
		SELECT
			created_by,
			user_ AS sender,
			CASE
				WHEN zero_for_one THEN pool
				ELSE fusdcAddress
			END AS from,
			CASE
				WHEN zero_for_one THEN fusdcAddress
				ELSE pool
			END AS to,
			CASE
				WHEN zero_for_one THEN amount0
				ELSE amount1
			END AS amount_in,
			CASE
				WHEN zero_for_one THEN amount1
				ELSE amount0
			END AS amount_out,
			transaction_hash
		FROM
			events_seawater_swap1
		WHERE created_by > after AND pool = filter
		ORDER BY created_by DESC
		LIMIT limit_
	)
) swaps
LEFT JOIN events_seawater_newpool fromPool
	ON swaps.token_in = fromPool.token
LEFT JOIN events_seawater_newpool toPool
	ON swaps.token_out = toPool.token;
$$;

-- migrate:down
