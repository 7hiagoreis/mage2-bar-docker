require(['jquery'], function ($) {
    $(document).ready(function () {
        const links = document.querySelectorAll('.switcher-language .switcher-option a');

        links.forEach(link => {
            link.addEventListener('click', function (e) {
                e.preventDefault();

                const targetUrl = new URL(this.href);
                targetUrl.searchParams.set('force_reload', '1');
                targetUrl.searchParams.set('v', Date.now()); // anti-cache

                window.location.href = targetUrl.toString();
            });
        });

        const currentUrl = new URL(window.location.href);
        if (currentUrl.searchParams.get('force_reload') === '1') {
            currentUrl.searchParams.delete('force_reload');
            currentUrl.searchParams.delete('v');
            window.location.replace(currentUrl.toString());
        }
    });
});
