module ReVIEW
  module Task
    module MD2ReVIEW
      def self.extended(mod)
        mod.instance_eval do
          rule '.print.re' => '.md' do |t|
            sh "md2review --render-link-in-footnote #{t.source} > #{t.name}"
          end

          rule '.ebook.re' => '.md' do |t|
            sh "md2review #{t.source} > #{t.name}"
          end

          CLEAN.include(print_sources, ebook_sources)
        end
      end

      def md_sources
        FileList['*.md']
      end

      def print_sources
        md_sources.ext('print.re')
      end

      def ebook_sources
        md_sources.ext('ebook.re')
      end
    end
  end
end
