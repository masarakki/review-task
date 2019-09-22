require 'rake'
require 'rake/tasklib'
require 'yaml'
require 'pry'

module ReVIEW
  module Task
    class RakeTask < ::Rake::TaskLib
      def initialize(ns = nil, &block)
        @review_config = YAML.load(File.read('config.yml'))
        require 'rake/clean'

        instance_eval(&block) if block_given?

        if ns
          namespace ns do
            define
          end
        else
          define
        end
      end

      def use(plugin)
        extend ReVIEW::Task.plugins[plugin]
      end

      def bookname
        @review_config['bookname']
      end

      def ebook_pdf
        "#{bookname}.ebook.pdf"
      end

      def print_pdf
        "#{bookname}.print.pdf"
      end

      def ebook_epub
        "#{bookname}.epub"
      end

      def epub_assets
        FileList['*.css']
      end

      def pdf_assets
        FileList['layouts/*.erb', 'sty/**/*.sty']
      end

      def print_sources
        FileList['*.re']
      end

      def ebook_sources
        FileList['*.re']
      end

      def define
        desc "create epub"
        task epub: ebook_epub

        desc "create pdf"
        task pdf: [print_pdf, ebook_pdf]

        namespace :pdf do
          %i[print ebook].each do |key|
            filename = send("#{key}_pdf")
            sources = send("#{key}_sources")

            desc "create #{filename}"
            task key => filename

            file filename => sources + pdf_assets do
              p filename, sources
              sh "review-pdfmaker config.yml"
            end
          end
        end

        file ebook_epub => ebook_sources + epub_assets do
          FileUtils.rm_rf [ebook_epub, "#{bookname}-epub"]
          sh "review-epubmaker config.yml"
        end

        CLEAN.include([print_pdf, ebook_pdf, ebook_epub, "#{bookname}-pdf", "#{bookname}-epub"])
      end
    end
  end
end
