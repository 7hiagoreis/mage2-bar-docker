<?php
namespace Treis\CustomFooter\Block;

use Magento\Framework\View\Element\Template;

class FooterLink extends Template
{
    protected function _prepareLayout()
    {
        // Remove os links padrão do Magento 2 no rodapé do Tema...
        $this->getLayout()->getBlock('footer_links')->unsetChildren();
        return parent::_prepareLayout();
    }
}
