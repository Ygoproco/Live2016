--漆黒のズムウォル
function c100000156.initial_effect(c)
	--dark synchro summon
	c:EnableReviveLimit()
	c100000156.tuner_filter=function(mc) return mc and mc:IsSetCard(0x301) end
	c100000156.nontuner_filter=function(mc) return true end
	c100000156.minntct=1
	c100000156.maxntct=1
	c100000156.sync=true
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c100000156.syncon)
	e1:SetOperation(c100000156.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--deckdes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100000156,0))
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(c100000156.tgcon)
	e3:SetTarget(c100000156.tgtg)
	e3:SetOperation(c100000156.tgop)
	c:RegisterEffect(e3)
	--add setcode
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_ADD_SETCODE)
	e4:SetValue(0x301)
	c:RegisterEffect(e4)
end
function c100000156.tmatfilter(c,syncard)
	return c:IsSetCard(0x301) and c:IsType(TYPE_TUNER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard)
end
function c100000156.ntmatfilter(c,syncard)	
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard) and c:IsNotTuner()
end
function c100000156.synfilter1(c,lv,tuner,syncard,pe,tc,ft)
	if c:GetFlagEffect(100000147)==0 then
		return tuner:IsExists(c100000156.synfilter2,1,c,true,lv,c,syncard,pe,tc,ft)
	else
		return tuner:IsExists(c100000156.synfilter2,1,c,false,lv,c,syncard,pe,tc,ft)
	end
end
function c100000156.synfilter2(c,add,lv,nontuner,syncard,pe,tc,ft)
	if ft<=0 and not Group.FromCards(nontuner,c):IsExists(Card.IsLocation,1,nil,LOCATION_MZONE) then return false end
	if pe and not Group.FromCards(nontuner,c):IsContains(pe:GetOwner()) then return false end
	if tc and not Group.FromCards(nontuner,c):IsContains(tc) then return false end
	if c.tuner_filter and not c.tuner_filter(nontuner) then return false end
	if nontuner.tuner_filter and not nontuner.tuner_filter(c) then return false end
	if not c:IsHasEffect(EFFECT_HAND_SYNCHRO) and nontuner:IsLocation(LOCATION_HAND) then return false end
	if not nontuner:IsHasEffect(EFFECT_HAND_SYNCHRO) and c:IsLocation(LOCATION_HAND) then return false end
	if (nontuner:IsHasEffect(EFFECT_HAND_SYNCHRO) or c:IsHasEffect(EFFECT_HAND_SYNCHRO)) and c:IsLocation(LOCATION_HAND) 
		and nontuner:IsLocation(LOCATION_HAND) then return false end
	local ntlv=nontuner:GetSynchroLevel(syncard)
	local lv1=bit.band(ntlv,0xffff)
	local lv2=bit.rshift(ntlv,16)
	if add then
		return c:GetSynchroLevel(syncard)==lv+lv1 or c:GetSynchroLevel(syncard)==lv+lv2
	else
		return c:GetSynchroLevel(syncard)==lv-lv1 or c:GetSynchroLevel(syncard)==lv-lv2
	end
end
function c100000156.syncon(e,c,tuner,mg)
	if c==nil then return true end
	local tp=c:GetControler()
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local tunerg=Duel.GetMatchingGroup(c100000156.tmatfilter,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	local nontuner=Duel.GetMatchingGroup(c100000156.ntmatfilter,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	return nontuner:IsExists(c100000156.synfilter1,1,nil,4,tunerg,c,pe,tuner,Duel.GetLocationCount(tp,LOCATION_MZONE))
end
function c100000156.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Group.CreateGroup()
	local tun=Duel.GetMatchingGroup(c100000156.tmatfilter,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	local nont=Duel.GetMatchingGroup(c100000156.ntmatfilter,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local nontmat=nont:FilterSelect(tp,c100000156.synfilter1,1,1,nil,4,tun,c,pe,tuner,ft)
	local mat1=nontmat:GetFirst()
	g:AddCard(mat1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local t
	if mat1:GetFlagEffect(100000147)==0 then
		t=tun:FilterSelect(tp,c100000156.synfilter2,1,1,mat1,true,4,mat1,c,pe,tuner,ft)
	else
		t=tun:FilterSelect(tp,c100000156.synfilter2,1,1,mat1,false,4,mat1,c,pe,tuner,ft)
	end
	g:Merge(t)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c100000156.tgcon(e,c)
	return Duel.GetAttackTarget()~=nil and Duel.GetAttackTarget():GetAttack()>e:GetHandler():GetBaseAttack()
end
function c100000156.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=math.floor((Duel.GetAttackTarget():GetAttack()-e:GetHandler():GetBaseAttack())/100)	
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,ct)
end
function c100000156.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttackTarget():GetAttack()>e:GetHandler():GetBaseAttack() then
		local ct=math.floor((Duel.GetAttackTarget():GetAttack()-e:GetHandler():GetBaseAttack())/100)	
		Duel.DiscardDeck(1-tp,ct,REASON_EFFECT)
	end
end
