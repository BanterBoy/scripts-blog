const themeCookie = 'scripts.lukeleigh.com',
    themeStorage = 'scripts.lukeleigh.com.theme';

const setPersistent = (theme) => {
    Cookies.set(themeCookie, { theme: theme }, { sameSite: 'strict' });
    localStorage.setItem(themeStorage, theme);
};

const applyTheme = (theme) => {
    if (theme === 'system') {
        removeTheme();

        $('body').removeClass('dark-theme');
        $('body').removeClass('light-theme');

        $('#btnApplyDarkTheme, #btnApplyLightTheme').show();
        $('#btnApplySystemTheme').addClass('active');

        return;
    }

    setPersistent(theme);

    $('#btnApplySystemTheme').removeClass('active');

    if (theme === 'light') {
        $('body').addClass('light-theme');
        $('body').removeClass('dark-theme');

        $('#btnApplyDarkTheme').show();
        $('#btnApplyLightTheme').hide();
    } else {
        $('body').addClass('dark-theme');
        $('body').removeClass('light-theme');

        $('#btnApplyDarkTheme').hide();
        $('#btnApplyLightTheme').show();
    }
};

const removeTheme = () => {
    try {
        Cookies.remove(themeCookie);
    }
    catch (e) {
        console.debug(e);
    }

    try {
        localStorage.removeItem(themeStorage);
    }
    catch (e) {
        console.debug(e);
    }
}

const getTheme = () => {
    var t = localStorage.getItem(themeStorage);

    if (t === null) {
        var c = Cookies.getJSON(themeCookie);

        if (c === undefined || c === null) {
            return 'system';
        }

        t = c.theme;

        setPersistent(t);
    }

    return t;
};

$(function () {
    applyTheme(getTheme());

    $.each(['Dark', 'Light', 'System'], function (i, theme) {
        $(`#btnApply${theme}Theme`).click(function () {
            applyTheme(theme.toLowerCase());
        });
    });
});