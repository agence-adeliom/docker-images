<?php

ignore_user_abort(true);

function handle_request(): void
{
    phpinfo();
}

if($_SERVER['FRANKENPHP_WORKER'] ?? false) {
        while (frankenphp_handle_request(handle_request(...))) {}
}

handle_request();