--ファーニマル・オクト
--Fluffal Octo
--Scripted by Eerie Code
function c87246309.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87246309,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,87246309)
	e1:SetTarget(c87246309.thtg)
	e1:SetOperation(c87246309.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,87246309+1)
	e3:SetCondition(c87246309.tgcon)
	e3:SetTarget(c87246309.tgtg)
	e3:SetOperation(c87246309.tgop)
	c:RegisterEffect(e3)
end

function c87246309.thfil(c)
	return (c:IsSetCard(0xc3) or c:IsSetCard(0xa9)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c87246309.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c87246309.thfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c87246309.thfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c87246309.thfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c87246309.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

function c87246309.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_FUSION)==REASON_FUSION and e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():GetReasonCard():IsSetCard(0xad)
end
function c87246309.tgfil(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c87246309.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c87246309.tgfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c87246309.tgfil,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(87246309,1))
	local g=Duel.SelectTarget(tp,c87246309.tgfil,tp,LOCATION_REMOVED,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c87246309.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	end
end
