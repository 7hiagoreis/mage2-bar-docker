<?php

namespace Treis\CustomEditor\Plugin;

class WysiwygConfigPlugin
{
    public function afterGetConfig(
        \Magento\Cms\Model\Wysiwyg\Config $subject,
        $result
    ) {

        $settings = $result->getData('settings') ?? [];

        $settings['menubar'] = 'file edit view insert format tools table help';

        $result->setData('settings', $settings);

        return $result;
    }
}
