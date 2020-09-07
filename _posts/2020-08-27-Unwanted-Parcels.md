---
layout: post
title: "Unwanted Parcels"
excerpt: "Why you really need to protect your accounts"
header:
  overlay_image: 
  overlay_filter: rgba(90, 104, 129, 0.7)
  teaser: 
toc_label: Unwanted Parcels
toc_icon: people-carry
toc_sticky: true
categories:
  - Blog
tags:
  - 2FA
  - Security
  - Password
  - Breach
  - Resources
---

<script src="https://formspree.io/js/formbutton-v1.0.0.min.js" defer></script>
<script>
  window.formbutton=window.formbutton||function(){(formbutton.q=formbutton.q||[]).push(arguments)};
/* customize formbutton here*/     
  formbutton("create", {
    action: "https://formspree.io/xvowjgjd",
    buttonImg: "<i class='fas fa-envelope' style='font-size:20px'/>",
    theme: "minimal",
    title: "Contact Me!",
    fields: [
      { 
        type: "email", 
        label: "Email:", 
        name: "email",
        required: true,
        placeholder: "your@email.com"
      },
      {
        type: "textarea",
        label: "Message:",
        name: "message",
        required: true,
        placeholder: "What's on your mind?",
      },
      { type: "submit" }      
    ],
    styles: {
      fontFamily: "Roboto",
      fontSize: "1em",
      title: {
        background: "#999999",
      },
      button: {
        background: "#999999",
      }
    },
    initiallyVisible: false
  });
</script>

{: .text-right}
<span style="font-size:11px;"><button onclick="window.print()"><i class="fas fa-print" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Print</button></span>

# <i class="fas fa-brain" aria-hidden="true" style="color: #303030; margin-right:5px;"></i> Reasons

Life seems full of irony lately. I recently had to help my son with a security issue, as he had fallen victim to someone accessing his Amazon account. This seems to have been the result of sharing the same passwords with multiple accounts; one of which was also his emails. As I have worked in the IT industry, securing infrastructure to PCI Compliance Security Standards for last 10 years, I was horrified that this had happened to someone I know; let alone to my son. It felt a little embarrassing as frequently expounding the virtues of security was kind of my thing and I have discussed password security with my son on numerous occasions.

Many who have a nineteen year old young adult living in their house, will attest to the fact "that they *haven't* listened to you for years and often *already* know what they are doing"; so it shouldn't really have come as much of a surprise that he hadn't taken any notice.

As a result of what happened, my son seems to have learnt a valuable lesson and is a lot more careful with his account details. I thought I would write this post so that his experience might also help convince others to be more careful in their security practices. *So, on with the embarrassing story.*

{: .text-right}
<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a></span>

# <i class="fas fa-bed" aria-hidden="true" style="color: #303030; margin-right:5px;"></i> Early wake up

Last Friday my son woke me in rather a panic, as he believed that he was the victim of a breach. He had already spoke to his mother and with her being at work, he was promptly told that he would have to wake me up. Having just been wrestled from my slumber, I mostly grunted, harrumphed and nodded my way through his description of events whilst trying to wake up. He explained that he had checked his bank account that morning to find somehow, someone had placed a number orders through his Amazon account on his behalf but he had changed his Amazon password in case this was how they had gained accessed.

Armed with all the relevant information, I now had to figure out what had actually happened and attempt to resolve the problem. I was also supposed to *try to get his money back.*

{: .text-right}
<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a></span>

# <i class="fas fa-coffee" aria-hidden="true" style="color: #303030; margin-right:5px;"></i> Investigation

As my son was visibly distressed, he had neglected to sensibly wake me with a coffee but given the circumstances I was willing to let it go, so I got dressed and headed out to the [man cave][4]{:target="_blank"} with my son in tow.

Once inside, I started making a coffee and began pondering my checklist while the kettle boiled.

{: .text-right}
<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a></span>

## <i class="fas fa-clipboard-list" aria-hidden="true" style="color: #303030; margin-right:5px;"></i> Accounts to check

  [<i class="fab fa-amazon" aria-hidden="true" style="font-size:12px; color: #303030; margin-right:10px;"></i>Amazon Account Settings][6]{:target="_blank"}<br>
  [<i class="fas fa-envelope-open-text" aria-hidden="true" style="font-size:12px; color: #303030; margin-right:10px;"></i>Email account][7]{:target="_blank"}<br>
  [<i class="fab fa-xbox" aria-hidden="true" style="font-size:12px; color: #303030; margin-right:10px;"></i>Xbox Account][8]{:target="_blank"}<br>
  [<i class="fab fa-paypal" aria-hidden="true" style="font-size:12px; color: #303030; margin-right:10px;"></i>PayPal][9]{:target="_blank"}<br>
  [<i class="fab fa-ebay" aria-hidden="true" style="font-size:12px; color: #303030; margin-right:10px;"></i>eBay][10]{:target="_blank"}<br>
  [<i class="fas fa-user" aria-hidden="true" style="font-size:12px; color: #303030; margin-right:10px;"></i>have I been pwned?][2]{:target="_blank"}<br>
  [<i class="fas fa-users" aria-hidden="true" style="font-size:12px; color: #303030; margin-right:10px;"></i>all social media accounts][11]{:target="_blank"}<br>
  
{: .text-right}
<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a></span>

## <i class="fas fa-mug-hot" aria-hidden="true" style="color: #303030; margin-right:5px;"></i> So it begins

Coffee ready, I sat down and began sifting through his Amazon account settings. I was amused to find that when my son had reset his password, he also had the sense to enable two factor authentication (I think I laughed when he told me but I can't be sure). All the settings checked out and they hadn't changed his address, phone number or email details. Whoever had accessed his account had placed 12 orders, 5 of which were printable vouchers for varying amounts, scattered in-between the random items they had ordered.

As the only reason my son knew that the orders were from Amazon was from his bank account, I checked his email account next. Sure enough, someone had also accessed his email and had configured some rules to delete emails coming from a number of sources; [PayPal][9]{:target="_blank"}, [eBay][10]{:target="_blank"}, and [Amazon][6]{:target="_blank"}. His email account had not yet been forwarded on to a different account which may have been due to how quickly he severed access to his accounts by resetting his passwords. He had been very lucky that whoever had access hadn't changed any contact details or indeed invaded any other accounts also sharing the same password.

{: .text-right}
<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a></span>

# <i class="fas fa-money-bill-wave" aria-hidden="true" style="color: #303030; margin-right:5px;"></i><i class="fas fa-coins" aria-hidden="true" style="color: #303030; margin-right:5px;"></i> Money gone?

Prior to waking me up, he had already called Amazon who told him to call the bank. He called the bank who told him he should speak to Amazon. No wonder he was frustrated and a bit panicked.

I checked the site ["have I been pwned?"][2]{:target="_blank"} to see if his email account had featured in any breaches, as his personal details including his email address and password could have been available to anyone on the internet. Sure enough his Email address and Password had appeared in three sets of compromised data.

{: .text-right}
<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a></span>

## <i class="fab fa-amazon" aria-hidden="true" style="color: #303030; margin-right:5px;"></i> Amazon

Having removed the rules deleting new emails and resetting passwords on any account that featured his bank details/debit card, son called Amazon and put the phone on speaker so I could help. Halfway through his explanation, they started to tell him to call the bank to stop the payments. I interrupted and explained that they had not only bought items that were being delivered to our house, they had also bought vouchers but we don't own a printer, they seemed to know what was happening and disappeared to speak to their manager.

When the agent returned to the call, he advised that he would need to access his account requiring my son to provide the 2FA code. Once he had access, he cancelled as many of the orders as possible but wasn't able to cancel all of them as they had been processed already. The departing comments were that the details would be passed to their **Investigations Team**, who would contact my son by email once they had completed their investigation in two days.

{: .text-right}
<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a></span>

## <i class="fas fa-piggy-bank" aria-hidden="true" style="color: #303030; margin-right:5px;"></i> Lloyds Bank

My son then placed a call to Lloyds on speakerphone and explained the issue. They started to advise that he contact Amazon as they were unable to cancel any of the payments but I interrupted and explained that we had already contacted Amazon and the issue was already with their investigations team; we were aware they were unable to do anything regarding the outstanding charges; but our expected outcome for the call was that they put a note my sons account indicating that he had already called advising there was an issue as this would help save time should he have to call again.

As it is now possible with most high street banks, my son then froze his card using the banking app. His card details were secure and he would need to cancel his card; but no more money could currently be spent and Amazon would be able to refund any payments to the card used in connection with the orders. Due to Amazon's actions, he had already had some of the money returned to his bank account, which he could now see in his mobile app.

{: .text-right}
<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a></span>

## <i class="fas fa-poll" aria-hidden="true" style="color: #303030; margin-right:5px;"></i> Outcome

My son was very fortunate in this instance as Amazon were quite helpful and had successfully recovered all of the money that had been spent (approx. £350). Amazon had told him that any orders that arrived, he was welcome to keep, give to charity or dispose of how he saw fit.

He contacted Lloyds again, soon after Amazon confirmed they had completed their investigation, and cancelled his debit card. Lloyds then sent out a new card, which he received the following day.

{: .text-right}
<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a></span>

# <i class="fas fa-sign-in-alt" aria-hidden="true" style="color: #303030; margin-right:5px;"></i> Two Factor Authentication (2FA)

It was now time for the standard password/authentication lecture.

Now normally it would just be a talk or some offered advice but clearly he needed to hear the speech again. [So I rambled on about sensible password choice and how sharing these between accounts was a very poor decision for the next 10 minutes][1]{:target="_blank"}, whilst making sure that he added 2FA to the accounts that provided the service. Having worked our way through the important accounts, I left him to finish up, insisting that he sorted this out before he went to work.

I went back out to the [man cave][4]{:target="_blank"} and subscribed my son's email to the [Have I been Pwned][12]{:target="_blank"} service, which monitors your email address against new breaches, just in case his details appeared on a new [pastebin][5]{:target="_blank"} lists. This way he would at least get some sort of advance warning by email.

{: .text-right}
<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a></span>

# <i class="fas fa-graduation-cap" aria-hidden="true" style="color: #303030; margin-right:5px;"></i> Lessons Learnt

| <i class="fas fa-lightbulb" aria-hidden="true" style="font-size:12px; color: #303030; margin-right:10px;"></i>My son now has more respect for his privacy and the fact that he is in control.<br>
| <i class="fas fa-lightbulb" aria-hidden="true" style="font-size:12px; color: #303030; margin-right:10px;"></i>He has learnt that the advantages of 2FA would have meant he would immediately be notified should anyone attempt to access his account, which would in turn have prevented anyone from spending his money for him.<br>
| <i class="fas fa-lightbulb" aria-hidden="true" style="font-size:12px; color: #303030; margin-right:10px;"></i>His password choices are more sensible and he is no longer sharing them with other accounts.<br>
| <i class="fas fa-lightbulb" aria-hidden="true" style="font-size:12px; color: #303030; margin-right:10px;"></i>He also sees the benefit of better password management and the ease of 2FA.<br>
| <i class="fas fa-lightbulb" aria-hidden="true" style="font-size:12px; color: #303030; margin-right:10px;"></i>I believe he also now checks his emails more frequently than every 2 months.<br>

{: .text-right}
<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a></span>

# <i class="fas fa-file-alt" aria-hidden="true" style="color: #303030; margin-right:5px;"></i> Resources

Anyone who is unsure they are following some form of "best practice" when managing their online accounts or that simply wants to know how to improve their own security should consider visiting the following sites. This obviously isn't a definitive guide but I hope your take away from reading any of this is to better arm yourself against the possibility of becoming the next victim.

The UK's [National Cyber Security Centre][3]{:target="_blank"} provides a plethora of information for home users and office workers. An excellent resource offering practical guidance for anyone looking to learn more about cyber security.

[Cyber Aware][1]{:target="_blank"} - is the UK government's advice on how to stay secure online and covers things like 2FA and password advice. It also coincidentally mirrors much of the advice I offered my son in my speech.

[HIBP][2]{:target="_blank"} - This link will take you to a site called "Have I been Pwned" which is a free resource for anyone to quickly assess if they may have been put at risk due to an online account of theirs having been compromised or "pwned" in a data breach.

{: .text-center}
<a href="#" class="btn btn--info btn--small"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a>

[1]: https://www.ncsc.gov.uk/cyberaware/home
[2]: https://haveibeenpwned.com/
[3]: https://www.ncsc.gov.uk/
[4]: /blog/build/Container-refurb-v6.0/
[5]: https://pastebin.com/
[6]: https://www.amazon.com
[7]: https://en.wikipedia.org/wiki/Comparison_of_webmail_providers
[8]: https://www.xbox.com/
[9]: https://www.paypal.com/
[10]: https://www.ebay.co.uk/
[11]: https://en.wikipedia.org/wiki/Social_media
[12]: https://haveibeenpwned.com/NotifyMe

